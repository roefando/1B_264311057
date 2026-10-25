CREATE TABLE mahasiswa (
    nim VARCHAR(100) NOT NULL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    semester INT(10) NOT NULL
 );
 
 CREATE TABLE dosen (
     nidn INT(10) NOT NULL PRIMARY KEY,
     nama_dosen VARCHAR(100) NOT NULL
);

CREATE TABLE matkul (
    kode_mk VARCHAR(100) NOT NULL PRIMARY KEY,
    nidn INT(10) NOT NULL,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT(10) NOT NULL,
    FOREIGN KEY (nidn) REFERENCES dosen(nidn) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE jadwal (
    id_jadwal VARCHAR(100) NOT NULL PRIMARY KEY,
    kode_mk VARCHAR(100) NOT NULL,
    hari VARCHAR(100) NOT NULL,
    jam VARCHAR(100) NOT NULL,
    ruang VARCHAR(100) NOT NULL,
    FOREIGN KEY (kode_mk) REFERENCES matkul(kode_mk) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE nilai (
    id_nilai VARCHAR(100) NOT NULL PRIMARY KEY,
    nim VARCHAR(100) NOT NULL,
    kode_mk VARCHAR(100) NOT NULL,
    nilai VARCHAR(5) NOT NULL, 
    semester VARCHAR(20) NOT NULL,
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (kode_mk) REFERENCES matkul(kode_mk) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE krs (
    id_krs VARCHAR(20) PRIMARY KEY,
    nim VARCHAR(20) NOT NULL,
    kode_mk VARCHAR(20) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    tahun_akademik VARCHAR(20) NOT NULL,
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (kode_mk) REFERENCES matkul(kode_mk) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cache (
    cache_key VARCHAR(50) PRIMARY KEY,
    cache_value TEXT NOT NULL,
    expired_at DATETIME NOT NULL
);

CREATE TABLE laporan (
    id_laporan VARCHAR(20) PRIMARY KEY,
    periode VARCHAR(50) NOT NULL,
    jenis_laporan VARCHAR(50) NOT NULL,
    data_laporan TEXT NOT NULL
);

-- Membuat index pada kolom Nama Mahasiswa
CREATE INDEX idx_nama_mahasiswa ON mahasiswa (nama);

-- Membuat index pada kolom Nama Mata Kuliah
CREATE INDEX idx_nama_matkul ON matkul (nama_mk);

-- Isi Data Mahasiswa
INSERT INTO mahasiswa (nim, nama, semester) VALUES 
('264311043', 'Glendy Devanno', 4),
('264311048', 'M. A. Hafidz', 4),
('264311056', 'Restu Prayuga', 4),
('264311057', 'Roefando Adji', 4);

-- Isi Data Dosen
INSERT INTO dosen (nidn, nama_dosen) VALUES 
('00123456', 'Dr. Budi Santoso, M.Kom.'),
('00654321', 'Siti Rahma, M.T.');

-- Isi Data Mata Kuliah
INSERT INTO matkul (kode_mk, nidn, nama_mk, sks) VALUES 
('IF101', '00123456', 'Pemrograman Basis Data', 3),
('IF102', '00654321', 'Struktur Data & Algoritma', 4);

-- Isi Data Jadwal
INSERT INTO jadwal (id_jadwal, kode_mk, hari, jam, ruang) VALUES 
('JDW01', 'IF101', 'Senin', '08:00 - 10:30', 'Lab RPL 1'),
('JDW02', 'IF102', 'Rabu', '10:30 - 13:00', 'Lab Komputer 2');

-- Isi Data KRS
INSERT INTO krs (id_krs, nim, kode_mk, semester, tahun_akademik) VALUES 
('KRS01', '264311043', 'IF101', '4', '2025/2026'),
('KRS02', '264311048', 'IF102', '4', '2025/2026');

-- Isi Data Nilai
INSERT INTO nilai (id_nilai, nim, kode_mk, nilai, semester) VALUES 
('NIL01', '264311043', 'IF101', 'A', '4'),
('NIL02', '264311048', 'IF102', 'B+', '4');

-- Memasukkan data rekapitulasi mahasiswa ke dalam tabel Cache
INSERT INTO cache (cache_key, cache_value, expired_at) VALUES 
(
    'rekap_mhs_264311043', 
    '{"nim": "264311043", "nama": "Glendy Devanno", "total_sks": 3, "ipk": 3.85}', 
    '2026-12-31 23:59:59'
),
(
    'rekap_mhs_264311048', 
    '{"nim": "264311048", "nama": "M. A. Hafidz", "total_sks": 4, "ipk": 3.50}', 
    '2026-12-31 23:59:59'
);

-- SKRIP DDL & DML: ADMIN PRODI & PEMBAYARAN UKT (100% CLEANED)
-- 1. TABEL ADMIN PRODI
CREATE TABLE admin_prodi (
    nip             VARCHAR(20)     PRIMARY KEY,
    nama_admin      VARCHAR(100)    NOT NULL,
    email           VARCHAR(100)    NULL,
    no_telepon      VARCHAR(15)     NULL
);

-- 2. TABEL REFERENSI KELOMPOK UKT
CREATE TABLE ref_kelompok_ukt (
    kelompok_ukt    INT             PRIMARY KEY,
    nominal         DECIMAL(12,2)   NOT NULL
);

-- 3. TABEL TAGIHAN UKT
CREATE TABLE tagihan_ukt (
    id_tagihan      VARCHAR(20)     PRIMARY KEY,
    nim             VARCHAR(100)    NOT NULL,
    semester        INT             NOT NULL,
    tahun_akademik  VARCHAR(20)     NOT NULL,
    kelompok_ukt    INT             NOT NULL,
    tgl_jatuh_tempo DATE            NOT NULL,
    status_tagihan  VARCHAR(15)     NOT NULL DEFAULT 'BELUM BAYAR',
    tgl_lunas       DATE            NULL,
    nip_penerbit    VARCHAR(20)     NOT NULL,
    CONSTRAINT fk_tagihan_mahasiswa FOREIGN KEY (nim) 
        REFERENCES mahasiswa(nim) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tagihan_kelompok FOREIGN KEY (kelompok_ukt) 
        REFERENCES ref_kelompok_ukt(kelompok_ukt) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tagihan_admin FOREIGN KEY (nip_penerbit) 
        REFERENCES admin_prodi(nip) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_tagihan_unik UNIQUE (nim, semester, tahun_akademik)
);

-- 4. TABEL PEMBAYARAN UKT
CREATE TABLE pembayaran_ukt (
    id_pembayaran       VARCHAR(20)     PRIMARY KEY,
    id_tagihan          VARCHAR(20)     NOT NULL,
    metode_bayar        VARCHAR(20)     NOT NULL,
    nominal_bayar       DECIMAL(12,2)   NOT NULL,
    tgl_bayar           DATE            NOT NULL,
    bukti_bayar         VARCHAR(255)    NULL,
    status_verifikasi   VARCHAR(15)     NOT NULL DEFAULT 'PENDING',
    tgl_verifikasi      DATE            NULL,
    nip_verifikator     VARCHAR(20)     NULL,
    keterangan          VARCHAR(255)    NULL,
    CONSTRAINT fk_bayar_tagihan FOREIGN KEY (id_tagihan) 
        REFERENCES tagihan_ukt(id_tagihan) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_bayar_admin FOREIGN KEY (nip_verifikator) 
        REFERENCES admin_prodi(nip) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- CONTOH DATA DUMMY (DML INSERT) UNTUK UKT & ADMIN PRODI

-- Insert Data Admin Prodi
INSERT INTO admin_prodi (nip, nama_admin, email, no_telepon) VALUES 
('198505102010011001', 'Siti Rahmawati', 'siti.admin@pnm.ac.id', '081234567890');

-- Insert Data Referensi Kelompok UKT
INSERT INTO ref_kelompok_ukt (kelompok_ukt, nominal) VALUES 
(1, 500000.00),
(2, 1000000.00),
(3, 1500000.00),
(4, 1800000.00),
(5, 2400000.00),
(6, 3000000.00),
(7, 3500000.00),
(8, 4000000.00);

-- Insert Data Tagihan UKT
INSERT INTO tagihan_ukt (id_tagihan, nim, semester, tahun_akademik, kelompok_ukt, tgl_jatuh_tempo, status_tagihan, tgl_lunas, nip_penerbit) VALUES 
('TGH-2026-001', '264311043', 4, '2025/2026', 3, '2026-09-15', 'LUNAS', '2026-09-10', '198505102010011001');

-- Insert Data Pembayaran UKT
INSERT INTO pembayaran_ukt (id_pembayaran, id_tagihan, metode_bayar, nominal_bayar, tgl_bayar, bukti_bayar, status_verifikasi, tgl_verifikasi, nip_verifikator, keterangan) VALUES 
('PAY-2026-001', 'TGH-2026-001', 'TRANSFER', 1500000.00, '2026-09-10', 'bukti_tf.jpg', 'TERVERIFIKASI', '2026-09-10', '198505102010011001', 'Pelunasan UKT Semester 4');

-- 3. TABEL TAMBAHAN: MODUL SIDANG TUGAS AKHIR
CREATE TABLE pendaftaran_sidang (
    id_sidang       VARCHAR(20)     PRIMARY KEY,
    nim             VARCHAR(100)    NOT NULL,
    periode_sidang  VARCHAR(50)     NOT NULL,
    judul_ta        VARCHAR(255)    NOT NULL,
    status_sidang   VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_sidang_mahasiswa FOREIGN KEY (nim) 
        REFERENCES mahasiswa(nim) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE dosen_penguji (
    id_penguji      VARCHAR(20)     PRIMARY KEY,
    id_sidang       VARCHAR(20)     NOT NULL,
    nidn            INT(10)         NOT NULL,
    peran_penguji   VARCHAR(50)     NOT NULL, -- Contoh: Ketua, Penguji 1, Pembimbing
    CONSTRAINT fk_penguji_sidang FOREIGN KEY (id_sidang) 
        REFERENCES pendaftaran_sidang(id_sidang) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_penguji_dosen FOREIGN KEY (nidn) 
        REFERENCES dosen(nidn) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE nilai_sidang (
    id_nilai_sidang VARCHAR(20)     PRIMARY KEY,
    id_sidang       VARCHAR(20)     NOT NULL,
    id_penguji      VARCHAR(20)     NOT NULL,
    nilai_angka     DECIMAL(5,2)    NOT NULL,
    catatan_revisi  TEXT            NULL,
    CONSTRAINT fk_nilaisidang_sidang FOREIGN KEY (id_sidang) 
        REFERENCES pendaftaran_sidang(id_sidang) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_nilaisidang_penguji FOREIGN KEY (id_penguji) 
        REFERENCES dosen_penguji(id_penguji) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert Pendaftaran Sidang
INSERT INTO pendaftaran_sidang (id_sidang, nim, periode_sidang, judul_ta, status_sidang) VALUES 
('SDG-2026-001', '264311043', '2025/2026 Genap', 'Implementasi Sistem Rekomendasi Berbasis Machine Learning', 'LULUS');

-- Insert Dosen Penguji untuk Sidang tersebut
INSERT INTO dosen_penguji (id_penguji, id_sidang, nidn, peran_penguji) VALUES 
('PGJ-01', 'SDG-2026-001', 00123456, 'Ketua Penguji'),
('PGJ-02', 'SDG-2026-001', 00654321, 'Sekretaris/Penguji 1');

-- Insert Nilai Sidang dari masing-masing Penguji
INSERT INTO nilai_sidang (id_nilai_sidang, id_sidang, id_penguji, nilai_angka, catatan_revisi) VALUES 
('NILSDG-01', 'SDG-2026-001', 'PGJ-01', 88.50, 'Perbaiki penulisan daftar pustaka pada bab 4.'),
('NILSDG-02', 'SDG-2026-001', 'PGJ-02', 85.00, 'Tingkatkan penjelasan pengujian black-box.');
