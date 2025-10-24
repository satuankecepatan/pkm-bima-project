### BAGIAN 1: INSTALASI DAN MEMUAT PAKET ###

packages <- c("readr", "dplyr", "tidyr", "tidytext")
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(readr)
library(dplyr)
library(tidyr)
library(tidytext)

### BAGIAN 2: MEMUAT DAN MEMILIH DATA REFLEKSI ###

data_file <- "data/LEMBAR EVALUASI KEGIATAN – PKM BIMA (Responses) - Form Responses 1.csv"
df_raw <- read_csv(data_file)

df_reflections <- df_raw %>%
  select(
    # Set Pertanyaan Utama (Q)
    Q1_Refleksi = `Refleksi Singkat Pertanyaan 1`,
    Q2_Refleksi = `Refleksi Singkat Pertanyaan 2`,
    Q3_Refleksi = `Refleksi Singkat Pertanyaan 3`,
    Q4_Refleksi = `Refleksi Singkat Pertanyaan 4`,
    Q5_Refleksi = `Refleksi Singkat Pertanyaan 5`,
    Q6_Refleksi = `Refleksi Singkat Pertanyaan 6`,
    Q7_Refleksi = `Refleksi Singkat Pertanyaan 7`,
    Q8_Refleksi = `Refleksi Singkat Pertanyaan 8`,
    Q9_Refleksi = `Refleksi Singkat Pertanyaan 9`,
    Q10_Refleksi = `Refleksi Singkat Pertanyaan 10`,
    # Set Pertanyaan Kedua (K)
    K1_Refleksi = `Alasan / Refleksi Pertanyaan 1`,
    K2_Refleksi = `Alasan / Refleksi Pertanyaan 2`,
    K3_Refleksi = `Alasan / Refleksi Pertanyaan 3`,
    K4_Refleksi = `Alasan / Refleksi Pertanyaan 4`,
    K5_Refleksi = `Alasan / Refleksi Pertanyaan 5`
  )

### BAGIAN 3: TIDY DATA DAN TOKENISASI ###

tidy_reflections <- df_reflections %>%
  pivot_longer(
    cols = everything(),
    names_to = "Question_ID", # Kolom baru untuk ID Pertanyaan (Q1_Refleksi, dll.)
    values_to = "text"        # Kolom baru untuk teks refleksi
  ) %>%
  filter(!is.na(text) & text != "-") # Hapus baris jika responden tidak mengisi

# Tokenisasi
tokenized_reflections <- tidy_reflections %>%
  unnest_tokens(word, text, token = "words")

### BAGIAN 4: HAPUS STOPWORDS ###

custom_stopwords <- tibble(
  word = c(
    "yg", "dgn", "utk", "ini", "itu", "yang", "dan", "di", "ke", "dari",
    "dengan", "untuk", "pada", "adalah", "sebagai", "saya", "kami", "sangat",
    "bisa", "dapat", "menjadi", "lebih", "banyak", "juga", "telah", "para",
    "dalam", "karena", "materi", "namun", "tidak", "sdh", "para", "shg",
    "kegiatan", "eco", "enzyme", "ecoenzyme", "lebah", "kelulut", "pkm",
    "praktikum", "peserta", "mahasiswa", "bima", "ulm",
    "dari", "hal", "saat", "jika", "tersebut", "selama", "akan", "sudah",
    "setelah", "lain", "lainnya", "tentang", "merupakan", "yaitu", "melakukan"
  )
)

# Hapus stopwords dan angka
cleaned_words <- tokenized_reflections %>%
  anti_join(custom_stopwords, by = "word") %>%
  filter(!grepl("\\d", word)) %>% # Hapus kata yang mengandung angka
  filter(!is.na(word))

### BAGIAN 5: HITUNG FREKUENSI PER PERTANYAAN DAN EKSPOR ###

word_freq_per_question <- cleaned_words %>%
  group_by(Question_ID, word) %>%
  summarise(n = n(), .groups = 'drop') %>%
  arrange(Question_ID, desc(n)) # Urutkan berdasarkan ID, lalu frekuensi

print("--- Analisis Frekuensi Kata per Pertanyaan ---")
print(word_freq_per_question, n = 50) # n=50 untuk menunjukkan beberapa grup

write.csv(
  word_freq_per_question,
  "analisis_tematik_per_pertanyaan.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
