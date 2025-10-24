# Analisis Evaluasi Kegiatan PKM BIMA - Eco-Enzyme & Lebah Kelulut

Repositori ini berisi data mentah, skrip analisis R, dan hasil evaluasi untuk kegiatan pembelajaran kontekstual (Field-based Learning) mahasiswa Biologi FMIPA ULM di Desa Padang Panjang.

---

## Ringkasan Analisis dan Temuan Utama

### 1. Pendahuluan

Analisis ini bertujuan untuk mengevaluasi pencapaian tiga tujuan utama kegiatan: (1) pemahaman dan keterampilan aplikasi *eco-enzyme*, (2) efektivitas peningkatan kompetensi dan kesadaran lingkungan, dan (3) kepuasan peserta terhadap *Field-based Learning* (FBL). Metodologi yang digunakan adalah analisis *mixed-methods*, menggabungkan statistik deskriptif kuantitatif dari kuesioner skala Likert (1-5) dan analisis tematik kualitatif (frekuensi kata, bigram, dan tematik per pertanyaan) dari respons esai.

### 2. Temuan Kuantitatif Utama (Apa yang Dinilai Peserta?)

Analisis deskriptif terhadap 15 item kuesioner (N=12) menunjukkan persepsi peserta yang sangat positif, namun juga mengidentifikasi satu tantangan utama.

* **Kepuasan Keseluruhan:** Item `Q10_Kepuasan` mencatat skor rata-rata (Mean) **$4.5$** dari $5.0$.
* **Persepsi Tertinggi:** Item `Q8_KesadaranLimbah` (Mean: **$4.67$**).
* **Keterampilan Tertinggi:** Item soft-skill `K1_Kerjasama` (Mean: **$4.5$**) dan item kesadaran `Q7_K3` (Kebersihan) (Mean: **$4.5$**).
* **Tantangan Utama (Skor Terendah):** Item `Q4_Observasi` ("Saya dapat mengamati dan mencatat... secara teliti") mencatat skor rata-rata terendah (Mean: **$3.58$**), menjadikannya satu-satunya item di bawah $4.0$.

Visualisasi skor rata-rata untuk semua item disajikan di bawah ini, dengan jelas menyoroti `Q4_Observasi` sebagai nilai terendah.

![Skor Rata-rata per Pertanyaan](results/plot_skor_rata_rata.png)

Analisis komparatif (`results/plot_perbandingan_gender.png`) menggunakan Uji Wilcoxon-Mann-Whitney tidak menunjukkan perbedaan yang signifikan secara statistik dalam skor kepuasan (Q10) antara peserta laki-laki dan perempuan ($p > 0.05$), menunjukkan pengalaman yang merata.

### 3. Tabel Ringkasan Analisis Triangulasi

Tabel berikut mensintesis temuan kuantitatif (skor) dengan temuan kualitatif (konteks teks) untuk memberikan gambaran lengkap.

| Kategori | Temuan Kunci (Kuantitatif) | Konteks (Kualitatif) |
| :--- | :--- | :--- |
| **Area Sukses #1: Kesadaran Limbah** | `Q8_KesadaranLimbah` (Mean: **$4.67$**) (Skor Tertinggi) | Refleksi `Q8` didominasi kata: `limbah` (n=12), `organik` (n=11), `solusi` (n=7). |
| **Area Sukses #2: Soft Skill (FBL)** | `K1_Kerjasama` (Mean: **$4.5$)** | Refleksi `K1` didominasi kata: `teman` (n=7), `bekerja sama` (n=11), `menghargai pendapat` (n=5). |
| **Area Tantangan: Keterampilan Teknis** | `Q4_Observasi` (Mean: **$3.58$**) (Skor Terendah) | Refleksi `Q4` adalah satu-satunya yang berisi kata: `sulit` (n=2) dan `kesulitan` (n=2). |
| **Kepuasan & Korelasi** | `Q10_Kepuasan` (Mean: **$4.5$**) | Sangat berkorelasi ($r_s > 0.7$) dengan dua area sukses (Q8 dan K1). |

### 4. Analisis Tematik Mendalam (Mengapa Skornya Seperti Itu?)

Dengan menghubungkan skor kuantitatif dengan data tematik per pertanyaan, kita dapat menjelaskan *mengapa* peserta memberikan skor tersebut.

#### A. Triangulasi Skor Tertinggi (Q8 & K1)

Skor tertinggi secara langsung divalidasi oleh kata kunci refleksi yang paling sering muncul:

* **Skor Tinggi: `Q8_KesadaranLimbah` (Mean $4.67$)**
    * **Alasan (Teks `Q8_Refleksi`):** Ketika merefleksikan item ini, kata kunci dominan peserta adalah `limbah` (n=12), `organik` (n=11), `solusi` (n=7), dan `ramah` (n=6). Ini membuktikan pemahaman konseptual yang mendalam.
* **Skor Tinggi: `K1_Kerjasama` (Mean $4.5$)**
    * **Alasan (Teks `K1_Refleksi`):** Refleksi untuk item ini didominasi oleh kata `teman` (n=7), `sama` (n=6), `bekerja` (n=5), `menghargai` (n=5), dan `pendapat` (n=5). Ini mengkonfirmasi keberhasilan FBL dalam fasilitasi *soft skill*.

#### B. Triangulasi Skor Terendah (Q4)

Skor terendah juga dijelaskan dengan sempurna oleh teks refleksinya, yang mengindikasikan **tantangan pelaksanaan**, bukan kegagalan pemahaman.

* **Skor Rendah: `Q4_Observasi` (Mean $3.58$)**
    * **Alasan (Teks `Q4_Refleksi`):** Ini adalah satu-satunya refleksi di mana kata kunci negatif muncul di daftar teratas. Selain kata-kata tugas (`aktivitas` n=7, `mencatat` n=6), peserta secara eksplisit menyebutkan **`sulit` (n=2)** dan **`kesulitan` (n=2)**.
    * **Interpretasi:** Skor $3.58$ secara akurat mencerminkan bahwa mahasiswa *memahami* tugas observasi tetapi merasa *paling tidak mampu* melaksanakannya secara teliti karena mengidentifikasi adanya "kesulitan" di lapangan.

### 5. Analisis Korelasi

Analisis korelasi Spearman (`results/plot_korelasi.png`) menguatkan temuan ini. Kepuasan keseluruhan (`Q10_Kepuasan`) menunjukkan korelasi positif yang sangat kuat dengan item yang paling berhasil: `K1_Kerjasama` ($r_s$ = $0.79$) dan `Q8_KesadaranLimbah` ($r_s$ = $0.74$).

![Plot Korelasi Spearman](results/plot_korelasi.png)

### 6. Kesimpulan dan Rekomendasi

Data kuantitatif dan kualitatif secara konvergen menunjukkan bahwa ketiga tujuan evaluasi telah tercapai:

1.  **Pemahaman & Keterampilan:** Tercapai. Peserta menunjukkan pemahaman konseptual yang sangat tinggi (terutama `Q8_KesadaranLimbah` Mean $4.67$) yang didukung oleh tema teks (`limbah organik` n=22).
2.  **Kesadaran Lingkungan:** Tercapai secara signifikan. Ini adalah temuan terkuat, didukung oleh skor Q8 dan dominasi tema `lingkungan` (n=63) serta `menjaga kebersihan` (n=13) dalam analisis teks.
3.  **Kepuasan FBL:** Tercapai dengan skor kepuasan tinggi (Mean $4.5$). Analisis triangulasi membuktikan bahwa kepuasan ini sangat didorong oleh dua pilar: keberhasilan dalam menumbuhkan kesadaran akan "limbah organik" dan fasilitasi "kerja sama" tim.

**Rekomendasi:** Temuan skor rendah (Mean $3.58$) dan teks kualitatif ("sulit", "kesulitan") pada `Q4_Observasi` memberikan masukan penting. Disarankan agar kegiatan di masa depan memberikan lebih banyak bimbingan, waktu, atau alat bantu untuk tugas observasi teliti, karena ini diidentifikasi sebagai tantangan terbesar oleh peserta.
