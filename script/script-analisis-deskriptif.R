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
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

### BAGIAN 2: MEMUAT DAN MEMBERSIHKAN DATA ###

data_file <- "data/LEMBAR EVALUASI KEGIATAN – PKM BIMA (Responses) - Form Responses 1.csv"

df <- read_csv(data_file)

# "Q" = Pertanyaan Utama (Pemahaman, Kepuasan)
# "K" = Pertanyaan Keterampilan (Kerja sama, dll.)
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
  # Konversi semua kolom yang dipilih menjadi tipe numerik (angka)
  # 'na.rm = TRUE' akan diabaikan di sini, tapi ini praktik yang baik
  mutate(across(everything(), as.numeric))

### BAGIAN 3: ANALISIS STATISTIK DESKRIPTIF ###

data_long <- df_numeric %>%
  pivot_longer(
    cols = everything(),           # Ambil semua kolom
    names_to = "Pertanyaan",       # Kolom baru untuk nama pertanyaan (Q1_Pemahaman, dll.)
    values_to = "Skor"             # Kolom baru untuk skor (1-5)
  ) %>%
  filter(!is.na(Skor)) # Hapus baris jika responden tidak mengisi (NA)

# Hitung statistik deskriptif untuk setiap pertanyaan
summary_stats <- data_long %>%
  group_by(Pertanyaan) %>%
  summarise(
    Mean = mean(Skor, na.rm = TRUE),
    Median = median(Skor, na.rm = TRUE),
    StdDev = sd(Skor, na.rm = TRUE),
    N = n() # Jumlah responden untuk pertanyaan tsb.
  ) %>%
  # Urutkan berdasarkan skor rata-rata, dari tertinggi ke terendah
  arrange(desc(Mean))

print("--- Hasil Analisis Statistik Deskriptif ---")
print(summary_stats, n = 20) # n=20 untuk memastikan semua 15 baris tercetak


### BAGIAN 4: EKSPOR HASIL KE CSV (UNTUK MS WORD) ###

write.csv(
  summary_stats,
  "analisis_kuantitatif.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


### BAGIAN 5: VISUALISASI DATA (OPSIONAL TAPI DISARANKAN) ###

# Buat plot bar chart untuk skor rata-rata setiap pertanyaan
# 'reorder(Pertanyaan, Mean)' mengurutkan bar dari terendah ke tertinggi
plot_skor_rata_rata <- ggplot(summary_stats, aes(x = Mean, y = reorder(Pertanyaan, Mean))) +
  geom_col(fill = "darkblue", alpha = 0.8) +
  geom_text(aes(label = round(Mean, 2)), hjust = -0.2, size = 3) + # Tambah label skor
  labs(
    title = "Rata-Rata Skor Jawaban Peserta per Pertanyaan",
    subtitle = "Skala 1 (Sangat Tidak Setuju) hingga 5 (Sangat Setuju)",
    x = "Skor Rata-Rata (Mean)",
    y = "Item Pertanyaan Evaluasi"
  ) +
  theme_minimal() +
  scale_x_continuous(limits = c(0, 5.5)) # Atur batas sumbu X agar label muat

print(plot_skor_rata_rata)

ggsave("plot_skor_rata_rata.png", plot = plot_skor_rata_rata, width = 10, height = 8)

print("Plot 'plot_skor_rata_rata.png' telah disimpan.")
