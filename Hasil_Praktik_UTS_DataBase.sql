--SOAL NO 1
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

CREATE TABLE krs (
    id_krs VARCHAR(20) PRIMARY KEY,
    nim VARCHAR(20) NOT NULL,
    kode_mk VARCHAR(20) NOT NULL,
    semester_krs VARCHAR(20) NOT NULL,
    tahun_akademik VARCHAR(20) NOT NULL,
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (kode_mk) REFERENCES matkul(kode_mk) ON DELETE CASCADE ON UPDATE CASCADE
);


--SOAL NO 2
-- 1. [CREATE] INSERT minimal 3 baris data dummy ke masing-masing tabel (Total 9 baris)
-- Insert Data ke Mahasiswa (3 baris)
INSERT INTO mahasiswa (nim, nama, semester) VALUES 
('264311043', 'Roefando Adji Ramadhan', 1),
('264311048', 'M. A. Hafidz', 1),
('264311056', 'Restu Prayuga', 1);

--insert Data ke dosen (3baris)
INSERT INTO dosen (nidn, nama_dosen) VALUES 
('00123456', 'Dr. Budi Santoso, M.Kom.'),
('00654321', 'Siti Rahma, M.T.'),
('00987654', 'Ahmad Fauzi, M.Cs.');

-- Insert Data ke Mata Kuliah (3 baris)
INSERT INTO matkul (kode_mk, nidn, nama_mk, sks) VALUES 
('IF101', '00123456', 'Pemrograman Basis Data', 3),
('IF102', '00654321', 'Struktur Data & Algoritma', 4),
('IF103', '00987654', 'Matematika Diskrit', 3);

-- Insert Data ke Tabel Transaksi KRS (3 baris)
INSERT INTO krs (id_krs, nim, kode_mk, semester_krs, tahun_akademik) VALUES 
('KRS01', '264311043', 'IF101', '1', '2026/2027'),
('KRS02', '264311048', 'IF102', '1', '2026/2027'),
('KRS03', '264311056', 'IF103', '1', '2026/2027');


-- 2. [READ] Tampilkan seluruh isi salah satu Tabel Induk
SELECT * FROM mahasiswa;


-- 3. [UPDATE] Ubah satu nilai data pada Tabel Transaksi menggunakan WHERE pada Primary Key
UPDATE krs 
SET kode_mk = 'IF101' 
WHERE id_krs = 'KRS03';


-- 4. [DELETE] Hapus salah satu baris data pada Tabel Transaksi menggunakan WHERE
DELETE FROM krs 
WHERE id_krs = 'KRS03';


--SOAL NO 3
SELECT 
    m.nim,
    m.nama,
    SUM(mk.sks) AS total_sks_diambil
FROM krs k
JOIN mahasiswa m ON k.nim = m.nim
JOIN matkul mk ON k.kode_mk = mk.kode_mk
WHERE k.semester_krs = '1'
GROUP BY m.nim, m.nama;
