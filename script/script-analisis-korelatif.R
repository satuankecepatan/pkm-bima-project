### BAGIAN 0: INSTALASI DAN MEMUAT PAKET ###

packages <- c("readr", "dplyr", "tidyr", "ggplot2", "tidytext", "corrplot")
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidytext)
library(corrplot)


### BAGIAN 1: DATA LOADING ###

data_file <- "data/LEMBAR EVALUASI KEGIATAN – PKM BIMA (Responses) - Form Responses 1.csv"
df_raw <- read_csv(data_file)


### BAGIAN 2: ANALISIS KORELASI (SPEARMAN) ###

df_numeric <- df %>%
  select(
    Q1_Pemahaman = `1.) Saya memahami dengan baik konsep dasar dan manfaat eco-enzyme bagi lingkungan dan ekosistem lebah kelulut.`,
    Q2_TeoriPraktik = `2.) Kegiatan ini membantu saya menghubungkan teori ekologi dan bioteknologi lingkungan dengan praktik nyata di lapangan.`,
    Q3_Aplikasi = `3.) Saya merasa mampu mengaplikasikan eco-enzyme di area sarang dengan teknik yang benar dan aman bagi koloni lebah.`,
    Q4_Observasi = `4.) Saya dapat mengamati dan mencatat aktivitas lebah kelulut secara teliti selama kegiatan.`,
    Q5_IdentifikasiHama = `5.) Saya memahami cara mengidentifikasi hama atau predator yang dapat mengganggu sarang lebah.`,
    Q6_KeterampilanSoft = `6.) Saya merasa kegiatan ini meningkatkan keterampilan observasi, kerja sama, dan komunikasi saya dengan tim.`,
    Q7_K3 = `7.) Saya belajar pentingnya menjaga kebersihan dan keamanan lingkungan kerja saat berinteraksi dengan lebah.`,
    Q8_KesadaranLimbah = `8.) Saya menyadari bahwa penggunaan eco-enzyme dapat menjadi solusi ramah lingkungan untuk mengurangi limbah organik.`,
    Q9_KesadaranPeran = `9.) Kegiatan ini menumbuhkan kesadaran saya untuk berperan aktif dalam menjaga kelestarian lingkungan.`,
    Q10_Kepuasan = `10.) Saya merasa puas dengan pelaksanaan kegiatan ini secara keseluruhan.`,
    K1_Kerjasama = `1.) Saya belajar bekerja sama dan menghargai pendapat teman selama kegiatan berlangsung.`,
    K2_AktifKreatif = `2.) Saya berperan aktif dan kreatif dalam setiap tahapan kegiatan.`,
    K3_TanggungJawab = `3.) Kegiatan ini menumbuhkan rasa tanggung jawab saya terhadap kelestarian alam dan makhluk hidup lain.`,
    K4_Motivasi = `4.) Saya termotivasi untuk menerapkan eco-enzyme di rumah atau dalam kegiatan masyarakat.`,
    K5_Pemahaman = `5.) Kegiatan ini membuat saya lebih memahami peran Generasi Z dalam mewujudkan pembangunan berkelanjutan (SDGs).`
  ) %>%
  mutate(across(everything(), as.numeric))

# Spearman cor
cor_matrix <- cor(df_numeric, method = "spearman", use = "complete.obs")

png("plot_korelasi.png", width = 10, height = 10, units = "in", res = 300)
corrplot(cor_matrix,
         method = "color",       # Tampilkan sebagai warna
         type = "upper",         # Tampilkan segitiga atas saja
         addCoef.col = "black",  # Tambahkan angka koefisien
         tl.col = "black",       # Warna teks label
         tl.srt = 45,            # Rotasi label
         number.cex = 0.7,       # Ukuran angka koefisien
         title = "Matriks Korelasi Spearman Antar Pertanyaan",
         mar = c(0, 0, 1, 0))    # Margin
dev.off() # Menutup file PNG


### BAGIAN 3: ANALISIS KOMPARATIF (GENDER) ###

df_gender <- df_raw %>%
  select(
    `JENIS KELAMIN`,
    Q10_Kepuasan = `10.) Saya merasa puas dengan pelaksanaan kegiatan ini secara keseluruhan.`
  ) %>%
  # Pastikan Q10 adalah numerik dan hapus NA
  mutate(Q10_Kepuasan = as.numeric(Q10_Kepuasan)) %>%
  filter(!is.na(Q10_Kepuasan), !is.na(`JENIS KELAMIN`))

# Uji Wilcoxon-Mann-Whitney
# Ini menguji apakah ada perbedaan signifikan dalam skor Q10 antara 2 grup
if (length(unique(df_gender$`JENIS KELAMIN`)) == 2) {
  test_hasil <- wilcox.test(Q10_Kepuasan ~ `JENIS KELAMIN`, data = df_gender)
  print("--- Uji Perbedaan Kepuasan (Q10) berdasarkan Jenis Kelamin ---")
  print(test_hasil)
} else {
  print("--- Uji Gender dilewati (hanya ada 1 grup jenis kelamin) ---")
}

plot_gender <- ggplot(df_gender, aes(x = `JENIS KELAMIN`, y = Q10_Kepuasan, fill = `JENIS KELAMIN`)) +
  geom_boxplot(alpha = 0.8) +
  geom_jitter(width = 0.1, alpha = 0.5) + # Tambahkan titik data individu
  labs(
    title = "Perbandingan Skor Kepuasan (Q10) berdasarkan Jenis Kelamin",
    y = "Skor Kepuasan (1-5)",
    x = "Jenis Kelamin"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("plot_perbandingan_gender.png", plot = plot_gender, width = 6, height = 5)

### BAGIAN 4: ANALISIS N-GRAM (BIGRAM / FRASA 2-KATA) ###

text_cols <- df_raw %>%
  select(
    contains("Refleksi Singkat"),
    `1. Apa hal paling berkesan yang Anda alami selama kegiatan ini?`,
    `2. Pengetahuan atau keterampilan baru apa yang Anda pelajari dari kegiatan ini?`,
    `3. Bagaimana kegiatan ini membantu Anda memahami pentingnya kerja sama dan kepedulian lingkungan?`,
    `4. Apa ide atau inovasi yang ingin Anda kembangkan dari kegiatan ini untuk diterapkan di lingkungan Anda?`,
    `5. Setelah mengikuti kegiatan ini, apa komitmen pribadi Anda terhadap lingkungan?`
  )

tidy_text <- text_cols %>%
  pivot_longer(
    cols = everything(),
    names_to = "sumber_pertanyaan",
    values_to = "teks"
  ) %>%
  filter(!is.na(teks) & teks != "-") # Hapus baris kosong

custom_stopwords <- tibble(
  word = c(
    "yg", "dgn", "utk", "ini", "itu", "yang", "dan", "di", "ke", "dari",
    "dengan", "untuk", "pada", "adalah", "sebagai", "saya", "kami", "sangat",
    "bisa", "dapat", "menjadi", "lebih", "banyak", "juga", "telah", "para",
    "dalam", "karena", "materi", "namun", "tidak", "sdh", "para", "shg",
    "kegiatan", "eco", "enzyme", "ecoenzyme", "lebah", "kelulut", "pkm",
    "praktikum", "peserta", "mahasiswa", "bima", "ulm"
  )
)

bigram_counts <- tidy_text %>%
  unnest_tokens(bigram, teks, token = "ngrams", n = 2) %>%
  filter(!is.na(bigram)) %>%
  separate(bigram, c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% custom_stopwords$word) %>%
  filter(!word2 %in% custom_stopwords$word) %>%
  count(word1, word2, sort = TRUE)

print("--- 20 Frasa (Bigram) Paling Sering Muncul ---")
print(head(bigram_counts, 20))

bigrams_united <- bigram_counts %>%
  unite(bigram, word1, word2, sep = " ")

write.csv(
  bigrams_united,
  "analisis_frekuensi_bigram.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
