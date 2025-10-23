### BAGIAN 1: INSTALASI DAN MEMUAT PAKET ###

if (!requireNamespace("readr", quietly = TRUE)) {
  install.packages("readr")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("tidyr", quietly = TRUE)) {
  install.packages("tidyr")
}
if (!requireNamespace("tidytext", quietly = TRUE)) {
  install.packages("tidytext")
}

library(readr)
library(dplyr)
library(tidyr)
library(tidytext)

### BAGIAN 2: MEMUAT DAN MEMPERSIAPKAN DATA ###

data_raw <- "data/LEMBAR EVALUASI KEGIATAN – PKM BIMA (Responses) - Form Responses 1.csv"

df <- read_csv(data_raw, col_types = cols(.default = "c"))

text_cols <- df %>%
  select(
    # Mengambil semua kolom yang namanya mengandung "Refleksi Singkat"
    contains("Refleksi Singkat"),
    # Menambahkan kolom pertanyaan terbuka lainnya secara eksplisit
    `1. Apa hal paling berkesan yang Anda alami selama kegiatan ini?`,
    `2. Pengetahuan atau keterampilan baru apa yang Anda pelajari dari kegiatan ini?`,
    `3. Bagaimana kegiatan ini membantu Anda memahami pentingnya kerja sama dan kepedulian lingkungan?`,
    `4. Apa ide atau inovasi yang ingin Anda kembangkan dari kegiatan ini untuk diterapkan di lingkungan Anda?`,
    `5. Setelah mengikuti kegiatan ini, apa komitmen pribadi Anda terhadap lingkungan?`
  )

tidy_text <- text_cols %>%
  pivot_longer(
    cols = everything(), # Ambil semua kolom yang sudah dipilih
    names_to = "sumber_pertanyaan", # Kolom baru untuk info asal pertanyaan
    values_to = "teks" # Kolom baru untuk isi teks
  ) %>%
  filter(!is.na(teks) & teks != "-") # Hapus baris yang teksnya kosong (NA atau "-")


### BAGIAN 3: ANALISIS FREKUENSI KATA (TIDYTEXT) ###

custom_stopwords <- tibble(
  word = c(
    # Stopwords umum Bahasa Indonesia
    "yg", "dgn", "utk", "ini", "itu", "yang", "dan", "di", "ke", "dari",
    "dengan", "untuk", "pada", "adalah", "sebagai", "saya", "kami", "sangat",
    "bisa", "dapat", "menjadi", "lebih", "banyak", "juga", "telah", "para",
    "dalam", "karena", "materi", "namun", "tidak", "sdh", "para", "shg",
    
    # Stopwords spesifik topik (agar tidak mendominasi hasil)
    "kegiatan", "eco", "enzyme", "ecoenzyme", "lebah", "kelulut", "pkm",
    "praktikum", "peserta", "mahasiswa", "bima", "ulm"
  )
)

word_freq <- tidy_text %>%
  unnest_tokens(word, teks) %>%       # 1. Pisahkan setiap kalimat menjadi kata (token)
  anti_join(custom_stopwords) %>%     # 2. Hapus semua kata yang ada di 'custom_stopwords'
  filter(!grepl("\\d+", word)) %>%    # 3. Hapus kata yang mengandung angka
  filter(nchar(word) > 2) %>%         # 4. Hapus kata yang terlalu pendek (misal: "s", "y")
  count(word, sort = TRUE)            # 5. Hitung frekuensi setiap kata, urutkan dari terbanyak

print("20 Kata Paling Sering Muncul (setelah dibersihkan):")
print(head(word_freq, 20))


### BAGIAN 4: EKSPOR HASIL KE CSV UNTUK MS WORD ###

write.csv(
  word_freq,
  "analisis_frekuensi_kata.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)