-- SOAL NO 3
SELECT 
    m.nim,
    m.nama,
    SUM(mk.sks) AS total_sks_diambil
FROM krs k
JOIN mahasiswa m ON k.nim = m.nim
JOIN matkul mk ON k.kode_mk = mk.kode_mk
WHERE k.semester_krs = '1'
GROUP BY m.nim, m.nama;
