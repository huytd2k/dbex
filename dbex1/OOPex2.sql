USE ql_bong_da;
/* 3 .a.1*/
SELECT ma_ct,ho_ten,so,vi_tri,ngay_sinh,dia_chi
FROM cau_thu;
/*3.a.2*/
SELECT *
FROM cau_thu ct
WHERE ct.so = 7 AND ct.vi_tri = 'Tien Ve';

/*3.a.3*/
SELECT ten_hlv,ngay_sinh,dia_chi,dien_thoai
FROM huan_luyen_vien;

/*3.a.4*/
SELECT * 
FROM cau_thu ct, cau_lac_bo clb 
WHERE 
ct.ma_clb = clb.ma_clb AND clb.ten_clb = 'BECAMEX BINH DUONG';

/*3.a.5*/
SELECT ct.ma_ct,ct.ho_ten,ct.ngay_sinh,ct.dia_chi,ct.vi_tri
FROM cau_thu ct, cau_lac_bo clb, quoc_gia qg
WHERE ct.ma_clb = clb.ma_clb AND ct.ma_qg = qg.ma_qg AND clb.ten_clb = 'SHB Da Nang' AND qg.ten_qg = 'Brazil';

/*3.a.6*/
SELECT *
FROM cau_thu ct, cau_lac_bo clb, san_van_dong svd
WHERE ct.ma_clb = clb.ma_clb AND clb.ma_san = svd.ma_san AND svd.ten_san = 'Long An';

/*3.a.7*/
SELECT td.ma_tran,td.ngay_td, svd.ten_san, clb1.ten_clb as ten_clb1, clb2.ten_clb as ten_clb2, ket_qua
FROM tran_dau td, cau_lac_bo clb1, cau_lac_bo clb2, san_van_dong svd
WHERE td.ma_clb1 = clb1.ma_clb AND td.ma_clb2 = clb2.ma_clb AND td.ma_san = svd.ma_san;

/*3.a.8*/
SELECT hlv.ma_hlv, hlv.ten_hlv, hlv.ngay_sinh, hlv.dia_chi, cnt.vai_tro, clb.ten_clb
FROM huan_luyen_vien hlv, cau_lac_bo clb, quoc_gia qg, hlv_clb cnt
WHERE  hlv.ma_qg = qg.ma_qg AND qg.ten_qg = 'Viet Nam' AND cnt.ma_hlv = hlv.ma_hlv AND cnt.ma_clb = clb.ma_clb;

/*3.a.9*/
SELECT clb.ten_clb
FROM bang_xh bxh, cau_lac_bo clb
WHERE bxh.ma_clb = clb.ma_clb AND bxh.vong = 3
ORDER BY bxh.diem DESC
LIMIT 3;

/*3.a.10*/
SELECT hlv.ma_hlv, hlv.ten_hlv, hlv.ngay_sinh, hlv.dia_chi, cnt.vai_tro, clb.ten_clb
FROM huan_luyen_vien hlv , hlv_clb cnt , cau_lac_bo clb, tinh
WHERE hlv.ma_hlv = cnt.ma_hlv AND clb.ma_clb = cnt.ma_clb AND clb.ma_tinh = tinh.ma_tinh AND tinh.ten_tinh = 'Binh Duong';

/*3.b.1*/
SELECT clb.ten_clb, COUNT(ct.ma_ct) as so_cau_thu
FROM  cau_thu ct INNER JOIN cau_lac_bo clb
ON ct.ma_clb = clb.ma_clb
GROUP BY clb.ten_clb;

/*3.b.2*/
SELECT clb.ten_clb, COUNT(ct.ma_ct) as so_cau_thu_viet_nam
FROM cau_thu ct INNER JOIN quoc_gia qg
ON  ct.ma_qg = qg.ma_qg
INNER JOIN cau_lac_bo clb
ON ct.ma_clb = clb.ma_clb
WHERE qg.ten_qg = 'Viet Nam'
GROUP BY clb.ma_clb;

/*3.b.3*/
SELECT clb.ma_clb,clb.ten_clb,svd.ten_san,svd.dia_chi, COUNT(*) as so_cau_thu_ngoai 
FROM cau_thu ct INNER JOIN quoc_gia qg
ON  ct.ma_qg = qg.ma_qg
INNER JOIN cau_lac_bo clb
ON   ct.ma_clb = clb.ma_clb 
INNER JOIN san_van_dong svd
ON  svd.ma_san = clb.ma_san
WHERE qg.ten_qg != 'Viet Nam'
GROUP BY clb.ma_clb
HAVING COUNT(ct.ma_ct) > 2;

/*3.b.4*/
SELECT tinh.ten_tinh, COUNT(ct.ma_ct) as so_cau_thu
FROM cau_thu ct INNER JOIN cau_lac_bo clb 
ON ct.ma_clb = clb.ma_clb
INNER JOIN tinh
ON  clb.ma_tinh = tinh.ma_tinh
WHERE ct.vi_tri = 'Tien dao'
GROUP BY tinh.ma_tinh; 

/*3.b.5*/
SELECT clb.ten_clb, tinh.ten_tinh
FROM cau_lac_bo clb 
INNER JOIN tinh
ON clb.ma_tinh = tinh.ma_tinh
INNER JOIN bang_xh
ON   bang_xh.ma_clb = clb.ma_clb
WHERE  bang_xh.vong = 3 AND bang_xh.nam = 2009 AND bang_xh.hang = 1;


/*3.c.1.a THIS WAY IS SAFER!*/
SELECT *
FROM huan_luyen_vien hlv 
WHERE hlv.ma_hlv IN (
	SELECT hlv.ma_hlv 
    FROM huan_luyen_vien hlv INNER JOIN hlv_clb cnt
    ON cnt.ma_hlv = hlv.ma_hlv
) AND hlv.dien_thoai = NULL;


/*3.c.1.b THIS WAY HAS BETTER PERFORMANCE BUT I'M NOT SURE IF IT'S RIGHT*/
SELECT DISTINCT hlv.ten_hlv 
FROM huan_luyen_vien hlv INNER JOIN hlv_clb cnt
ON hlv.ma_hlv = cnt.ma_hlv
WHERE hlv.dien_thoai = NULL; 

/*3.c.2*/
SELECT 
    hlv.ten_hlv
FROM
    huan_luyen_vien hlv
    INNER JOIN
    quoc_gia qg
    ON  qg.ma_qg = hlv.ma_qg
WHERE
    hlv.ma_hlv NOT IN ( /* FIND A COACH NOT IN TABLE OF TABLE COACH JOIN  TABLE COACH_CLUB */
    SELECT hlv.ma_hlv
	FROM huan_luyen_vien hlv
	JOIN hlv_clb cnt 
    ON hlv.ma_hlv = cnt.ma_hlv
    )
AND qg.ten_qg = 'Viet Nam';
        
 /*3.c.3*/       
SELECT *
FROM cau_thu ct
WHERE ct.ma_clb IN 
(
    SELECT clb.ma_clb 
    FROM cau_lac_bo clb INNER JOIN bang_xh on clb.ma_clb = bang_xh.ma_clb
    WHERE bang_xh.hang > 6 or bang_xh.hang < 3 AND bang_xh.vong = 3 AND bang_xh.nam = 2009
);
 
 /*3.c.4*/
SELECT tran_dau.ngay_td, svd.ten_san, clb1.ten_clb as ten_clb1, clb2.ten_clb as ten_clb2 
FROM tran_dau, san_van_dong svd
, cau_lac_bo clb1, cau_lac_bo clb2 WHERE 
    clb1.ma_clb IN (
        SELECT
            clb.ma_clb
        FROM
            cau_lac_bo clb,
            bang_xh
        WHERE
            bang_xh.ma_clb = clb.ma_clb
            AND bang_xh.vong = 3
            AND bang_xh.nam = 2009
            AND bang_xh.hang = 1
)
AND tran_dau.ma_clb1 = clb1.ma_clb 
AND tran_dau.ma_clb2 = clb2.ma_clb
AND svd.ma_san = tran_dau.ma_san

UNION 

SELECT tran_dau.ngay_td, svd.ten_san, clb1.ten_clb, clb2.ten_clb 
FROM tran_dau, san_van_dong svd
, cau_lac_bo clb1, cau_lac_bo clb2 WHERE 
    clb2.ma_clb IN (
        SELECT
            clb.ma_clb
        FROM
            cau_lac_bo clb,
            bang_xh
        WHERE
            bang_xh.ma_clb = clb.ma_clb
            AND bang_xh.vong = 3
            AND bang_xh.nam = 2009
            AND bang_xh.hang = 1
)
AND tran_dau.ma_clb1 = clb1.ma_clb 
AND tran_dau.ma_clb2 = clb2.ma_clb
AND svd.ma_san = tran_dau.ma_san;