-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 01, 2021 at 04:39 PM
-- Server version: 5.7.24
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pos`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `gb_get_combobox` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition` VARCHAR(50))  BEGIN
 
 IF (v_status = 'plan') THEN
      SELECT
        kli.item_id AS code,
        kli.item_name AS name
      FROM kqr_land_items kli
      WHERE kli.item_type = '3'
      AND kli.item_inactive = '0'
      AND kli.branchcode = v_branchcode;
  ELSEIF (v_status = 'type') THEN
      SELECT
        kli.item_id AS code,
        kli.item_name AS name
      FROM kqr_land_items kli
      WHERE kli.item_type = '0'
      AND kli.item_inactive = '0'
      AND kli.branchcode = v_branchcode;
  ELSEIF (v_status = 'size') THEN
      SELECT
        kli.item_id AS code,
        kli.item_name AS name
      FROM kqr_land_items kli
      WHERE kli.item_type = '1'
      AND kli.item_inactive = '0'
      AND kli.branchcode = v_branchcode;
  ELSEIF (v_status = 'street') THEN
      SELECT
        kli.item_id AS code,
        kli.item_name AS name
      FROM kqr_land_items kli
      WHERE kli.item_type = '2'
      AND kli.item_inactive = '0'
      AND kli.branchcode = v_branchcode;
  ELSEIF (v_status = 'customer_land') THEN
      SELECT
        kli.cus_id AS code,
        kli.cus_nameeng AS name
      FROM kqr_land_customers kli
      WHERE kli.cus_inactive = '0'
      AND kli.branchcode = v_branchcode;
  ELSEIF (v_status = 'land_location') THEN
      SELECT
        kli.id AS code,
        kli.name AS name
      FROM kqr_sys_provinces kli;
  ELSEIF (v_status = 'land') THEN
      SELECT
        kli.rg_id AS code,
        kli.rg_name AS name
      FROM kqr_land_register_items kli
      WHERE kli.inactive = '0'
      AND kli.branchcode = v_branchcode;
  ELSEIF (v_status = 'percent') THEN
      SELECT
        glp.percent AS code,
        glp.percent_name AS name
      FROM gb_list_percent glp
      WHERE glp.type = 'land';
  ELSEIF (v_status = 'E.Plan') THEN
      SELECT
        a.item_id AS code,
        a.item_name AS name
      FROM kqr_land_items AS a
      WHERE a.item_type = '0'
      AND a.item_inactive = '0'
      AND a.branchcode = v_branchcode;
  ELSEIF (v_status = 'E.Land') THEN
      SELECT
        a.rg_id AS code,
        a.rg_name AS name
      FROM kqr_land_register_items AS a
      WHERE a.inactive = '0'
      AND a.branchcode = v_branchcode;
  ELSEIF (v_status = 'E.Other') THEN
      SELECT
        a.item_id AS code,
        a.item_name AS name
      FROM kqr_land_items AS a
      WHERE a.item_type = '4' 
      AND a.item_inactive = '0'
      AND a.branchcode = v_branchcode;
  ELSEIF (v_status = 'pos_line') THEN
  	  SELECT CONVERT('' , CHAR CHARACTER SET utf8)  as id ,CONVERT('' , CHAR CHARACTER SET utf8)  as name  FROM dual
	  union
  	  SELECT a.line_id  as id,
  	         a.line_name as name
  	  FROM pos_tbl_proline as a 
  	  WHERE a.branchcode=v_branchcode AND a.line_type LIKE CONCAT(v_condition, '%') and a.inactive='0' ORDER BY id;
  ELSEIF (v_status = 'pos_supply_active') THEN
  	  SELECT CONVERT('' , CHAR CHARACTER SET utf8)  as id ,CONVERT('' , CHAR CHARACTER SET utf8)  as name  FROM dual
	  union
  	  SELECT a.sup_id  as id,
  	         a.sup_name as name
  	  FROM pos_tbl_supplier as a 
  	  WHERE a.branchcode=v_branchcode AND a.sup_id LIKE CONCAT(v_condition, '%') and a.inactive='0';
  ELSEIF (v_status = 'post_cat') THEN
   	  SELECT CONVERT('' , CHAR CHARACTER SET utf8)  as id ,CONVERT('' , CHAR CHARACTER SET utf8)  as name  FROM dual
	  union
      SELECT
        a.cat_id AS id,
        a.cat_name AS name
      FROM gb_sys_post_category AS a
      WHERE a.inactive='0' ORDER BY id ;
  ELSEIF (v_status = 'pos_product') THEN
  
   		SELECT CONVERT('' , CHAR CHARACTER SET utf8)  as id ,CONVERT('' , CHAR CHARACTER SET utf8)  as name  FROM dual
	  	union
      	SELECT
	        a.pro_id AS id,
	        a.pro_name AS name
        FROM pos_tbl_products AS a
        WHERE a.branchcode =v_branchcode ORDER BY id ;
  ELSEIF (v_status = 'gender') then
  		select a.con_value  as id ,
  			   a.con_display as  name 
  		from gb_sys_contant_fix a where a.con_name=v_condition;
  ELSEIF (v_status='coffee_size')then
		select a.line_id as id,
			   a.line_name as name 
		from coffee_tbl_line a 
		where a.branchcode LIKE CONCAT(v_branchcode, '%') and a.line_id LIKE CONCAT(v_condition, '%') and a.line_type='02' and a.inactive='0'
		order by a.line_id ;
    ELSEIF (v_status='coffee_coupon')then
    	select a.con_value  as id ,
    		   a.con_display  as name 
    	from gb_sys_contant_fix a 
    	where a.con_name='coffee_coupon' order by a.con_value;

  END IF;
  

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GB_MODIFY_NEXT_ID` (IN `v_con_name` VARCHAR(255), IN `v_type` VARCHAR(20), OUT `v_number` VARCHAR(255))  BEGIN


  DECLARE select_var varchar(20);
  DECLARE v_len int;
  SET v_len = 4;


  	IF EXISTS ( SELECT v_con_name FROM gb_sys_contants gsc WHERE gsc.con_name = v_con_name) THEN

    	SET select_var = IFNULL(( SELECT MAX(con_values) + 1 FROM gb_sys_contants AS AB WHERE AB.con_name = v_con_name), 1);

		UPDATE gb_sys_contants SET con_values = select_var WHERE con_name = v_con_name;

	ELSE

		INSERT INTO gb_sys_contants (con_name, con_values, con_remake) VALUES (v_con_name, '1', v_con_name);
	END IF;


	IF (v_type = '1') THEN
	    SET select_var = RIGHT(1000000 + select_var, v_len);
	ELSEIF (v_type = '2') THEN
		SET select_var = CONCAT(LEFT(v_con_name, 3), '-', RIGHT(1000000 + select_var, v_len));
	ELSEIF (v_type = '9') THEN
		SET select_var = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d'), '-', RIGHT(1000000 + select_var, v_len));
	ELSEIF (v_type = '10') THEN
		SET select_var = CONCAT(LEFT(UUID(), 7), '-', RIGHT(1000000 + select_var, v_len));
	END IF;


  	SET v_number = select_var;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gb_next_id_branch` (IN `v_branchcode` VARCHAR(25), IN `v_line_num` VARCHAR(30), IN `v_type` VARCHAR(20), OUT `v_num_value` VARCHAR(255))  BEGIN
	
	DECLARE select_var varchar(20);
  	DECLARE v_len int;
 	SET v_len = 4;
 
	IF EXISTS ( SELECT gsc.num_values FROM gb_number_next_by_branch gsc WHERE gsc.line_number = v_line_num and gsc.branchcode=v_branchcode) THEN

    	SET select_var = IFNULL(( SELECT MAX(num_values) + 1 FROM gb_number_next_by_branch gsc WHERE gsc.line_number = v_line_num and gsc.branchcode=v_branchcode), 1);

		UPDATE gb_number_next_by_branch SET num_values = select_var WHERE line_number = v_line_num and branchcode=v_branchcode;
		

	ELSE

		INSERT INTO gb_number_next_by_branch (branchcode,line_number,num_values,num_remake) VALUES (v_branchcode, v_line_num, '1',v_line_num);
		SET select_var='1';
	END IF;
	
	IF (v_type = '0') THEN
	    SET select_var = RIGHT(1000000 + select_var, v_len);
	ELSEIF (v_type = '1') THEN
	 	SET select_var = CONCAT(v_branchcode, '-',RIGHT(1000000 + select_var, v_len));
	ELSEIF (v_type = '2') THEN
		SET select_var = CONCAT(LEFT(v_con_name, 3), '-', RIGHT(1000000 + select_var, v_len));
	ELSEIF (v_type = '9') THEN
		SET select_var = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d'), '-', RIGHT(1000000 + select_var, v_len));
	ELSEIF (v_type = '10') THEN
		SET select_var = CONCAT(LEFT(UUID(), 7), '-', RIGHT(1000000 + select_var, v_len));
	END IF;

  	SET v_num_value = select_var;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_product` (IN `s` CHAR(20))  BEGIN
SELECT
  *
FROM kqr_tbl_products
WHERE sub_menu LIKE s;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_add_fee` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_inv_num` VARCHAR(25), IN `v_trancode` VARCHAR(20), IN `v_amount_fee` DECIMAL(13,4))  BEGIN
	
	DECLARE v_remark 	varchar(250);

	IF (v_trancode ='01') THEN 
	
		SET v_remark = CONCAT('Fee of delivery ',' invoice : ',v_inv_num) ;
	
	END IF ;


	IF (v_status = 'I') THEN
	
		CALL gb_next_id_branch(v_branchcode,'pos_fee', '0', v_code);
	
	
		DELETE a FROM  pos_tbl_fee AS a WHERE a.branchcode =v_branchcode and a.trancode =v_trancode and a.inv_num =v_inv_num;
	
		INSERT INTO pos_tbl_fee (sysnum,branchcode,inv_num,trancode,amount,remark,trandate) values (v_code,v_branchcode,v_inv_num,v_trancode,v_amount_fee,v_remark,now());
		
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_rpt_get_count_stock` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_stockcode` VARCHAR(20), IN `v_product` VARCHAR(200), IN `v_date_from` DATE, IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
	IF (v_status = 'count') THEN
		DROP TABLE IF EXISTS tmp_tbl_count_stock;

	
		SELECT a.tran_code ,
			   a.inputter,
			   DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate ,
			   a.remark ,
			   b.pro_code ,
			   CAST(b.qty AS DECIMAL(10,0)) as qty,
			   a.stockcode ,
			   c.line_name as stockname,
			   d.pro_name ,
			   b.sysdocnum 
		FROM pos_tbl_count_stock AS a 
		INNER JOIN pos_tbl_count_stock_detail as b on a.branchcode =b.branchcode and a.tran_code=b.tran_code 
		INNER JOIN pos_tbl_proline AS c on a.branchcode =b.branchcode and a.stockcode=c.line_id 
		inner JOIN pos_tbl_products AS d on b.branchcode =d.branchcode and b.pro_code=d.pro_id 
		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') 
		  AND a.stockcode  LIKE CONCAT(IFNULL(v_stockcode,'%'), '%')  
		  AND b.pro_code  LIKE CONCAT(IFNULL(v_product,'%'), '%')  
		  AND DATE(a.inputdate) BETWEEN v_date_from AND v_date_to
		  ORDER BY a.tran_code ;
		
	END IF;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_rpt_get_income` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_line` VARCHAR(50), IN `v_currency` VARCHAR(50), IN `v_date_from` DATE, IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
	IF (v_status = 'income') THEN
	
		
		SELECT a.tran_code,
			   a.inputter ,
			   DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate,
			   a.amount ,
			   c.currencyname as currency,
			   b.line_name,
			   IFNULL(a.referent,'') as referent,
			   IFNULL(a.remark,'') as remark
		FROM pos_tbl_income as a 
		inner join pos_tbl_proline as b on a.branchcode =b.branchcode and a.lin_id=b.line_id 
		inner join gb_tbl_currency as c on a.currency=c.currencycode 
	    WHERE a.branchcode  LIKE CONCAT(IFNULL(v_branchcode,'%'), '%') 
	     	   AND a.currency   LIKE CONCAT(IFNULL(v_currency,'%'), '%')
	     	   AND a.lin_id   LIKE CONCAT(IFNULL(v_line,'%'), '%')
	     	   AND DATE(a.inputdate) BETWEEN v_date_from AND v_date_to
	    ORDER BY a.tran_code ,a.inputdate ;
	
	ELSEIF (v_status = 'expense') THEN
		SELECT a.tran_code,
			   a.inputter ,
			   DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate,
			   a.amount ,
			   c.currencyname as currency,
			   b.line_name,
			   IFNULL(a.referent,'') as referent,
			   IFNULL(a.remark,'') as remark
		FROM pos_tbl_expense as a 
		inner join pos_tbl_proline as b on a.branchcode =b.branchcode and a.lin_id=b.line_id 
		inner join gb_tbl_currency as c on a.currency=c.currencycode 
	    WHERE a.branchcode  LIKE CONCAT(IFNULL(v_branchcode,'%'), '%') 
	     	   AND a.currency   LIKE CONCAT(IFNULL(v_currency,'%'), '%')
	     	   AND a.lin_id   LIKE CONCAT(IFNULL(v_line,'%'), '%')
	     	   AND DATE(a.inputdate) BETWEEN v_date_from AND v_date_to
	    ORDER BY a.tran_code ,a.inputdate ;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_rpt_get_product_in_stock` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_stock` VARCHAR(20), IN `v_product` VARCHAR(200), IN `v_type` VARCHAR(50), IN `v_line` VARCHAR(50), IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
 IF (v_status = 'product') THEN
			DROP TABLE IF EXISTS tmp_tbl_products;
			DROP TABLE IF EXISTS tmp_tbl_transactions;
		
			CREATE TEMPORARY TABLE tmp_tbl_products
			
			SELECT a.pro_id ,
				   a.branchcode ,
				   a.barcode ,
				   a.pro_name ,
				   a.pro_cost ,
				   a.pro_up ,
				   a.pro_discount,
				   b.line_name as pro_typ,
				   c.line_name  as pro_line 
			FROM pos_tbl_products as a 
			inner join pos_tbl_proline as b on a.branchcode =b.branchcode  and a.pro_type=b.line_id 
			inner join pos_tbl_proline as c on a.branchcode =c.branchcode  and a.pro_line =c.line_id 
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') 
				  AND a.pro_type  LIKE CONCAT(IFNULL(v_type,'%'), '%') 
				  AND a.pro_line  LIKE CONCAT(IFNULL(v_line,'%'), '%')
				  AND a.pro_id  LIKE CONCAT(IFNULL(v_product,'%'), '%');
		
			CREATE TEMPORARY TABLE tmp_tbl_transactions
			SELECT a.pro_code as pro_id,
				   a.branchcode,
				   a.stockcode,
				   sum(CAST(a.trn_qty AS DECIMAL(10,0))) as trn_qty
			FROM pos_tbl_transactions as a 
			inner join tmp_tbl_products as b on a.branchcode=b.branchcode and a.pro_code=b.pro_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') 
 				  AND a.pro_code  LIKE CONCAT(IFNULL(v_product,'%'), '%')
 				  AND a.stockcode  LIKE CONCAT(IFNULL(v_stock,'%'), '%') 
 				  AND DATE(a.inputdate)<=v_date_to
 				  GROUP BY a.pro_code,
						   a.branchcode,
						   a.stockcode;
			SELECT a.pro_id ,
				   a.branchcode ,
				   a.barcode ,
				   a.pro_name ,
				   a.pro_cost ,
				   a.pro_up ,
				   a.pro_discount,
				   a.pro_typ,
				   a.pro_line,
				   b.stockcode,
				   c.line_name as stock,
				   b.trn_qty
			FROM tmp_tbl_products AS a 
			inner join tmp_tbl_transactions as b on a.branchcode=b.branchcode and a.pro_id=b.pro_id
			inner join pos_tbl_proline as c on b.branchcode =c.branchcode  and b.stockcode =c.line_id 
			WHERE b.trn_qty<>0
			ORDER BY a.pro_id;
	 
		END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_rpt_get_purchase` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_stock` VARCHAR(20), IN `v_product` VARCHAR(200), IN `v_type` VARCHAR(50), IN `v_line` VARCHAR(50), IN `v_date_from` DATE, IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
	 IF (v_status = 'purchase') THEN
		DROP TABLE IF EXISTS tmp_tbl_purchase;
		DROP TABLE IF EXISTS tmp_tbl_transactions;
		
		CREATE TEMPORARY TABLE tmp_tbl_purchase
		SELECT a.pur_id ,
			   a.branchcode ,
			   a.pur_invoice ,
			   a.remark ,
			   b.sup_name ,
			   a.inputter ,
			    DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate 
		FROM pos_tbl_purchase_order as a 
		inner join pos_tbl_supplier as b on a.branchcode =b.branchcode and a.sup_id =b.sup_id 
		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') 
				  AND DATE(a.inputdate) BETWEEN v_date_from and v_date_to;
				 
		SELECT a.pur_id ,
			   a.branchcode ,
			   a.pur_invoice ,
			   a.remark ,
			   a.sup_name ,
			   a.inputter ,
			   a.inputdate ,
			   b.sysdonum ,
			   bb.line_name as stock,
			   b.pro_cost ,
			   b.pro_up ,
			   CAST(b.pro_qty AS DECIMAL(10,0)) as qty ,
			   b.pro_discount ,
			   b.pur_amount ,
			   c.pro_name,
			   d.line_name as pro_typ
		FROM tmp_tbl_purchase as a 
		inner join pos_tbl_purchase_details as b on a.branchcode=b.branchcode and a.pur_id=b.pur_id 
		inner join  pos_tbl_proline as bb on b.branchcode =bb.branchcode and b.stockcode =bb.line_id 
		inner join pos_tbl_products as c on b.branchcode=c.branchcode and  b.pro_code=c.pro_id 
		inner join pos_tbl_proline as d on d.branchcode =c.branchcode  and d.line_id =c.pro_type 
		WHERE c.pro_type  LIKE CONCAT(IFNULL(v_type,'%'), '%') 
				  AND c.pro_line  LIKE CONCAT(IFNULL(v_line,'%'), '%')
				  AND c.pro_id  LIKE CONCAT(IFNULL(v_product,'%'), '%')
				  AND b.stockcode LIKE CONCAT(IFNULL(v_stock,'%'), '%');
	 
				  
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_rpt_get_sold_out` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_product` VARCHAR(200), IN `v_type` VARCHAR(50), IN `v_line` VARCHAR(50), IN `v_date_from` DATE, IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
	 IF (v_status = 'sold_out') THEN
		DROP TABLE IF EXISTS tmp_tbl_invoices;
		DROP TABLE IF EXISTS tmp_tbl_transactions;
		
	
	    CREATE TEMPORARY TABLE tmp_tbl_invoices
		SELECT a.inv_num,
			   a.branchcode,
			   b.cus_name ,
			   CONCAT(b.cus_name ,'- Phone:',b.cus_phone) as cus_info,
			   a.inputter ,
			   a.inputdate 
		FROM pos_tbl_invoices as a 
		inner join pos_tbl_customers as b on a.branchcode =b.branchcode and a.cus_id =b.cus_id 
		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND DATE(a.inputdate) BETWEEN v_date_from AND v_date_to;
		
		SELECT a.inv_num,
			   a.branchcode,
			   a.cus_name ,
			   a.cus_info,
			   a.inputter,
			   DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate,
			   c.pro_name ,
			   d.line_name as pro_type,
			   CAST(b.pro_qty AS DECIMAL(10,0)) as qty ,
			   b.pro_cost ,
			   b.pro_up ,
			   b.pro_discount ,
			   b.pro_amount 
		FROM tmp_tbl_invoices as a 
	    inner join pos_tbl_stockouts as b on a.branchcode=b.branchcode and a.inv_num=b.inv_num 
	    inner join pos_tbl_products as c on c.branchcode =b.branchcode and c.pro_id=b.pro_code 
	    inner join pos_tbl_proline as d on d.branchcode =c.branchcode  and d.line_id =c.pro_type 
	    WHERE c.pro_type  LIKE CONCAT(IFNULL(v_type,'%'), '%') 
	  	AND c.pro_line  LIKE CONCAT(IFNULL(v_line,'%'), '%')
	  	AND c.pro_id  LIKE CONCAT(IFNULL(v_product,'%'), '%')
	    ORDER BY a.inv_num,b.pro_code ;
	    
	ELSEIF (v_status = 'sold_out_return') THEN
		DROP TABLE IF EXISTS tmp_tbl_invoices_return;
		DROP TABLE IF EXISTS tmp_tbl_transactions;
		
	
	    CREATE TEMPORARY TABLE tmp_tbl_invoices_return
		SELECT a.inv_num,
			   a.branchcode,
			   b.cus_name ,
			   CONCAT(b.cus_name ,'- Phone:',b.cus_phone) as cus_info,
			   a.inputter ,
			   a.inv_reason,
			   a.inputdate 
		FROM pos_tbl_invoice_return as a 
		inner join pos_tbl_customers as b on a.branchcode =b.branchcode and a.cus_id =b.cus_id 
		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND DATE(a.inputdate) BETWEEN v_date_from AND v_date_to;
		
		SELECT a.inv_num,
			   a.branchcode,
			   a.cus_name ,
			   a.cus_info,
			   a.inputter,
			   a.inv_reason,
			   DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate,
			   c.pro_name ,
			   d.line_name as pro_type,
			   CAST(b.pro_qty AS DECIMAL(10,0)) as qty ,
			   b.pro_cost ,
			   b.pro_up ,
			   b.pro_discount ,
			   b.pro_amount 
		FROM tmp_tbl_invoices_return as a 
	    inner join pos_tbl_stockout_return as b on a.branchcode=b.branchcode and a.inv_num=b.inv_num 
	    inner join pos_tbl_products as c on c.branchcode =b.branchcode and c.pro_id=b.pro_code 
	    inner join pos_tbl_proline as d on d.branchcode =c.branchcode  and d.line_id =c.pro_type 
	    WHERE c.pro_type  LIKE CONCAT(IFNULL(v_type,'%'), '%') 
	  	AND c.pro_line  LIKE CONCAT(IFNULL(v_line,'%'), '%')
	  	AND c.pro_id  LIKE CONCAT(IFNULL(v_product,'%'), '%')
	    ORDER BY a.inv_num,b.pro_code ;
	END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pos_rpt_get_stock_transfer` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_stockfrom` VARCHAR(20), IN `v_stockto` VARCHAR(20), IN `v_product` VARCHAR(200), IN `v_date_from` DATE, IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
IF (v_status = 'count') THEN
		
		SELECT a.tran_code ,
			   a.inputter ,
			   DATE_FORMAT(a.inputdate ,'%l:%i %p %b %e, %Y') as inputdate ,
			   a.f_stock ,
			   aa.line_name as stockfrom,
			   a.t_stock ,
			   ab.line_name  as stockto,
			   a.remark ,
			   b.sysdocnum ,
			   CAST(b.qty AS DECIMAL(10,0)) as qty,
			   b.pro_code,
			   d.pro_name 
		FROM pos_tbl_stocktransfer  AS a 
		INNER JOIN pos_tbl_proline AS aa on a.branchcode =aa.branchcode and a.f_stock =aa.line_id 
		INNER JOIN pos_tbl_proline AS ab on a.branchcode =ab.branchcode and a.t_stock =ab.line_id 
		inner join pos_tbl_stocktransfer_detail as b on a.branchcode =b.branchcode and a.tran_code=b.tran_code 
		inner JOIN pos_tbl_products AS d on b.branchcode =d.branchcode and b.pro_code=d.pro_id 
		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') 
		  AND a.f_stock   LIKE CONCAT(IFNULL(v_stockfrom,'%'), '%')  
		  AND a.t_stock   LIKE CONCAT(IFNULL(v_stockto,'%'), '%')  
		  AND b.pro_code  LIKE CONCAT(IFNULL(v_product,'%'), '%')  
		  ORDER BY a.tran_code ;
		
	END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_employees` (IN `v_status` VARCHAR(25), IN `v_name` VARCHAR(255), IN `v_address` VARCHAR(255), IN `v_created_at` DATE)  BEGIN

  declare vsubm_id varchar(50);

  SET vsubm_id = ( SELECT
    MAX(id) + 1 AS id
  FROM tbl_employees);


	INSERT INTO tbl_employees (id, employee_name, address, created_at)
	VALUES (vsubm_id, v_name, v_address, v_created_at);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_main_menu` (IN `v_status` VARCHAR(25), IN `v_menuid` VARCHAR(255), IN `v_menu_name` VARCHAR(255), IN `v_inactive` VARCHAR(255), IN `v_inputter` VARCHAR(255), IN `v_icon1` VARCHAR(255), IN `v_icon2` VARCHAR(255), IN `v_icon3` VARCHAR(255), IN `v_class1` VARCHAR(255), IN `v_class2` VARCHAR(255), IN `v_class3` VARCHAR(255))  BEGIN
 DECLARE vsubm_id varchar(50);

	IF (v_status = 'i') THEN
		CALL GB_MODIFY_NEXT_ID('main_menu', '1', vsubm_id);
	
			INSERT INTO tbl_main_left_menu (menu_id, menu_name, menu_effective_date, menu_inactive, menu_inputer , menu_glyphicon1, menu_glyphicon2, menu_glyphicon3, menu_class1, menu_class2, menu_class3)
			  VALUES (vsubm_id, v_menu_name, SYSDATE(), v_inactive, v_inputter, v_icon1, v_icon2, v_icon3, v_class1, v_class2, v_class3);
	
	ELSEIF (v_status = 'U') THEN
		UPDATE tbl_main_left_menu
			SET menu_name = v_menu_name,
				menu_inactive = v_inactive,
				menu_glyphicon1 = v_icon1,
				menu_glyphicon2 = v_icon2,
				menu_glyphicon3 = v_icon3,
				menu_class1 = v_class1,
				menu_class2 = v_class2,
				menu_class3 = v_class3
	
			WHERE menu_id = v_menuid;
	
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_permission_by_branch` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_profile_id` VARCHAR(25), IN `v_menu_id` VARCHAR(25), IN `v_view` TINYINT, IN `v_booking` TINYINT, IN `v_edit` TINYINT, IN `v_delete` TINYINT, IN `v_token` VARCHAR(50), IN `v_inputter` VARCHAR(50))  BEGIN
 DECLARE vsubm_id varchar(50);

  IF (v_status = 'I' ) THEN
  	
  	DELETE a FROM tbl_menu_permission_branch  as a where a.keytoken<>v_token AND a.profile_id =v_profile_id and a.branchcode=v_branchcode;

	CALL gb_next_id_branch(v_branchcode,'permission_branch', '1', vsubm_id);
	

	 INSERT INTO tbl_menu_permission_branch (per_id,menu_id,profile_id ,branchcode ,views,booking,edit,deletes,keytoken,inputter ,inputdate) 
			VALUES (vsubm_id,v_menu_id,v_profile_id,v_branchcode,v_view,v_booking,v_edit,v_delete,v_token,v_inputter,SYSDATE());

  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_permission_gb` (IN `v_status` VARCHAR(25), IN `v_menu_id` VARCHAR(25), IN `v_systemid` VARCHAR(25), IN `v_pro_id` VARCHAR(25), IN `v_token` VARCHAR(50), IN `v_inputter` VARCHAR(50), IN `v_view` TINYINT, IN `v_booking` TINYINT, IN `v_edit` TINYINT, IN `v_delete` TINYINT)  BEGIN
  DECLARE vsubm_id varchar(50);

  IF (v_status = 'I' ) THEN
  	
  	DELETE a FROM gb_tbl_permission as a where a.keytoken<>v_token AND a.systemid=v_systemid and a.menu_id=v_menu_id and a.pro_id=v_pro_id ;

	CALL GB_MODIFY_NEXT_ID('gb_permission', '1', vsubm_id);
	
	 INSERT INTO gb_tbl_permission (per_id,menu_id,systemid,pro_id,views,booking,edit,deletes,keytoken,inputter ,inputdate) VALUES (vsubm_id,v_menu_id,v_systemid,v_pro_id,v_view,v_booking,v_edit,v_delete,v_token,v_inputter,SYSDATE());

  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_permssion` (IN `v_status` VARCHAR(25), IN `v_system` VARCHAR(25), IN `v_menu_id` VARCHAR(25), IN `v_view` TINYINT, IN `v_booking` TINYINT, IN `v_edit` TINYINT, IN `v_delete` TINYINT, IN `v_token` VARCHAR(50), IN `v_inputter` VARCHAR(50))  BEGIN
   DECLARE vsubm_id varchar(50);

  IF (v_status = 'I' ) THEN
  	
  	DELETE a FROM tbl_menu_permission as a where a.keytoken<>v_token AND a.systemid=v_system and a.menu_id=v_menu_id ;

	CALL GB_MODIFY_NEXT_ID('permission_menu', '1', vsubm_id);
	
	 INSERT INTO tbl_menu_permission (per_id,systemid,menu_id,views,booking,edit,deletes,keytoken,inputter ,inputdate) VALUES (vsubm_id,v_system,v_menu_id,v_view,v_booking,v_edit,v_delete,v_token,v_inputter,SYSDATE());

  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_profile` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(255), IN `v_profileid` VARCHAR(255), IN `v_profilename` VARCHAR(255), IN `v_inactive` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
  SELECT v_status;
  IF (v_status = 'admin') THEN
	 
  	  INSERT INTO gb_profile_by_branch (profileid,branchcode,profilename,inactive,trandate,inputter) VALUES (v_profileid,v_branchcode,v_profilename,v_inactive,NOW(),v_inputter);


  END IF;
	
 
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_sub_menu` (IN `v_status` VARCHAR(25), IN `v_subm_id` VARCHAR(255), IN `v_menu_id` VARCHAR(255), IN `v_subm_name` VARCHAR(255), IN `v_subm_function` VARCHAR(255), IN `v_inactive` VARCHAR(255), IN `v_controller` VARCHAR(255), IN `v_subm_inputer` VARCHAR(255))  BEGIN

  DECLARE v_subofbranch varchar(50);
  DECLARE vsubm_id varchar(50);

  	IF (v_status = 'I') THEN

		CALL GB_MODIFY_NEXT_ID('sum_menu', '1', vsubm_id);
		
		SET vsubm_id=CONCAT('SUB', vsubm_id);
	
		INSERT INTO tbl_sub_left_menu (subm_id, menu_id, subm_name, subm_function, subm_inactive, subm_controller ,subm_inputer, subm_effective_date)
	  	VALUES (vsubm_id, v_menu_id, v_subm_name, v_subm_function, v_inactive,v_controller, v_subm_inputer, NOW());

	ELSEIF (v_status = 'U') THEN
		
		UPDATE tbl_sub_left_menu set 
				menu_id=v_menu_id,
				subm_name=v_subm_name,
				subm_function=v_subm_function,
				subm_inactive=v_inactive,
				subm_controller=v_controller
		WHERE subm_id=v_subm_id;
	
	END IF;




END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_system_controls` (IN `v_status` VARCHAR(25), IN `v_sys_con_id` VARCHAR(255), IN `v_sys_con_name` VARCHAR(255), IN `v_sys_con_short_name` VARCHAR(255), IN `v_sys_con_effective` DATE, IN `v_sys_con_inactive` VARCHAR(255), IN `v_sys_con_remark` VARCHAR(255), IN `v_sys_con_inputer` VARCHAR(255))  BEGIN
   DECLARE vsubm_id varchar(50);

  IF (v_status = 'I') THEN

	CALL GB_MODIFY_NEXT_ID('system_control_id', '1', vsubm_id);

	INSERT INTO gb_system_controls (sys_con_id, sys_con_name, sys_con_inactive, sys_con_short_name, sys_con_effective, sys_con_remark, inputdate , inputter)
  		   VALUES (vsubm_id, v_sys_con_name, v_sys_con_inactive, v_sys_con_short_name, v_sys_con_effective, v_sys_con_remark, NOW(), v_sys_con_inputer);
  ELSE
		UPDATE gb_system_controls
		SET sys_con_name = v_sys_con_name,
		    sys_con_inactive = v_sys_con_inactive,
		    sys_con_short_name = v_sys_con_short_name,
		    sys_con_effective = v_sys_con_effective,
		    sys_con_remark = v_sys_con_remark
	
		WHERE sys_con_id = v_sys_con_id;

  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_system_profile` (IN `v_status` VARCHAR(25), IN `v_pro_id` VARCHAR(255), IN `v_branchcode` VARCHAR(255), IN `v_pro_name` VARCHAR(255) CHARSET utf8, IN `v_inactive` VARCHAR(25), IN `v_inputter` VARCHAR(255))  BEGIN
   	DECLARE vprofile_id varchar(50);
 
  	IF (v_status = 'I') THEN

		CALL gb_next_id_branch(v_branchcode,'profile_id', '1', vprofile_id);
	
		INSERT INTO gb_profile_by_branch (profileid,branchcode,profilename,inactive,trandate,inputter) VALUES (vprofile_id,v_branchcode,v_pro_name,v_inactive,NOW(),v_inputer);

	ELSEIF v_status = 'U' THEN
	
		UPDATE 	gb_profile_by_branch  SET 
				profilename=v_pro_name,
				inactive=v_inactive
		WHERE branchcode=v_branchcode AND profileid=v_pro_id;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_userinfo` (IN `v_status` VARCHAR(25), IN `v_userid` VARCHAR(25), IN `v_countrycode` VARCHAR(25), IN `v_full_name` VARCHAR(250), IN `v_contact` VARCHAR(250), IN `v_gender` VARCHAR(25), IN `v_bio` VARCHAR(255), IN `v_image_name` VARCHAR(255), IN `v_inputter` VARCHAR(255))  begin
 	
		DECLARE vuser_id varchar(50);

	IF (v_status = 'I') then

		if not exists (select a.id from gb_sys_user_info a where a.id = v_userid limit 1)then
			insert into gb_sys_user_info(id,countrycode,gender,Bio,photo,trandate) values (v_userid,v_countrycode,v_gender,v_bio,v_image_name,now());
		else
			update 	gb_sys_user_info as a set
					a.gender= v_gender ,
					a.countrycode=v_countrycode,
					a.Bio=v_bio,
					a.photo=v_image_name
			 where a.id=v_userid;
		end if ;
	
			update gb_sys_users as a set
				   a.contact=v_contact,
				   a.name=v_full_name
			where a.id=v_userid;
	END IF;

	select vuser_id as trancode ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_users` (IN `v_status` VARCHAR(25), IN `v_user_id` VARCHAR(255), IN `v_branchcode` VARCHAR(255), IN `v_vsubofbranch` VARCHAR(255), IN `v_user_name` VARCHAR(255), IN `v_login_name` VARCHAR(255), IN `v_password` VARCHAR(255), IN `v_pwd_salt` VARCHAR(255), IN `v_supper` VARCHAR(25), IN `v_system` VARCHAR(25), IN `v_contact` VARCHAR(25), IN `v_inactive` VARCHAR(25), IN `v_profile` VARCHAR(25), IN `v_referent` VARCHAR(25), IN `v_inputter` VARCHAR(255))  BEGIN
 DECLARE v_subofbranch varchar(50);
  DECLARE vsubm_id varchar(50);
  DECLARE vprofile_id varchar(50);
  DECLARE v_userid varchar(50);

  IF (v_status = 'I') THEN
  	
	  	IF (v_referent = 'admin') THEN

	  		set v_userid=v_user_id;
	  		set vprofile_id=ifnull((select b.pro_id from gb_system_controls a  inner join gb_tbl_profile b on a.sys_con_id=b.systemid and b.systemid =v_system order by b.pro_id limit  1),'');
	  	
	  	ELSE
	  	
	  		CALL gb_next_id_branch(v_branchcode,'user_id', '1', v_userid);
	  		SET vprofile_id= v_profile;
	  		
	  	END IF;
	
	
	 	INSERT  INTO gb_sys_users (id,email,password,salt,name,contact,conpassword,supper,branchcode,subofbranch,systemid,Inactive,profile,inputter ,trandate)
	 			VALUES (v_userid,v_login_name,v_password,v_pwd_salt,v_user_name,v_contact,v_password,v_supper,v_branchcode,v_vsubofbranch,v_system,v_inactive,vprofile_id,v_inputter,NOW());
  ELSEIF (v_status = 'U') THEN
  			
  	UPDATE gb_sys_users
  		   set  name =v_user_name,
  		   	    contact=v_contact,
  		   	    profile=v_profile,
  		   	    Inactive=v_inactive
  	WHERE  branchcode =v_branchcode and  id =v_user_id;
  
  
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_auth_trans_by_branch` (IN `v_status` VARCHAR(25), IN `branchcode` VARCHAR(25), IN `v_id` VARCHAR(255))  BEGIN
	
	 IF v_status = 'land_items' THEN
	 	
	 	SELECT 'ddd';
	 
	 END IF;
	
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_auto_menu_permission` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_profile` VARCHAR(25), IN `v_systemid` VARCHAR(25))  BEGIN
DECLARE p_profile_id varchar(50);
	DECLARE p_systemid varchar(50);
	
	IF (v_status = 'auto') THEN
	
		DELETE FROM tbl_menu_permission_branch WHERE branchcode=v_branchcode AND profile_id=v_profile;
		
		INSERT INTO tbl_menu_permission_branch (
				per_id,
				menu_id,
				profile_id,
				branchcode,
				views,
				booking,
				edit,
				deletes,
				keytoken,
				inputdate,
				inputter)
		SELECT CONCAT(v_branchcode, '-auto',m.per_id) as id,
			    m.menu_id,
			    v_profile,
			    v_branchcode,
			    '1' AS views,
			    '1' AS booking,
			    '1' AS edit,
			    '1' AS deletes,
			    CONCAT(v_branchcode, '-',v_systemid) as keytoken ,
			    SYSDATE() AS SYSDATE,
			    'IT.SYSTEM' AS inputter
		FROM tbl_menu_permission AS m 
		WHERE m.systemid=v_systemid;
	
	ELSEIF (v_status = 'by_branch') THEN
 		
		SET p_profile_id =(SELECT a.profile FROM gb_sys_users as a where a.branchcode=v_branchcode ORDER BY a.trandate desc LIMIT 1 );
		SET p_systemid = (SELECT a.systemid FROM gb_sys_users as a where a.branchcode=v_branchcode and a.profile=p_profile_id ORDER BY a.trandate LIMIT 1 );
		
		DELETE FROM tbl_menu_permission_branch WHERE branchcode=v_branchcode AND profile_id=p_profile_id;

				INSERT INTO tbl_menu_permission_branch (
				per_id,
				menu_id,
				profile_id,
				branchcode,
				views,
				booking,
				edit,
				deletes,
				keytoken,
				inputdate,
				inputter)
		SELECT CONCAT(v_branchcode, '-auto',m.per_id) as id,
			    m.menu_id,
			    p_profile_id,
			    v_branchcode,
			    '1' AS views,
			    '1' AS booking,
			    '1' AS edit,
			    '1' AS deletes,
			    CONCAT(v_branchcode, '-',p_systemid) as keytoken ,
			    SYSDATE() AS SYSDATE,
			    'IT.SYSTEM' AS inputter
		FROM tbl_menu_permission AS m 
		WHERE m.systemid=p_systemid;
	
				
	END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_check_sql_land` (IN `v_status` VARCHAR(25), IN `v_id` VARCHAR(255), IN `v_branchcode` VARCHAR(25))  BEGIN
	  DECLARE vchecking varchar(50);
	  DECLARE specialty CONDITION FOR SQLSTATE '45000';
	  
	 IF v_status = 'land_line' THEN
	 	
		    SET vchecking='';
		
			SET vchecking=IFNULL((SELECT a.rg_id 
			FROM kqr_land_register_items as a 
			WHERE  EXISTS (
							SELECT b.item_id 
							FROM kqr_land_items as b 
							where a.type_id=b.item_id AND b.branchcode=v_branchcode AND b.item_id=v_id
						  )
			ORDER BY rg_id DESC LIMIT 1),'');
		
			
			IF(vchecking='')THEN
			
				SET vchecking=IFNULL((SELECT a.rg_id 
				FROM kqr_land_register_items as a 
				WHERE  EXISTS (
								SELECT b.item_id 
								FROM kqr_land_items as b 
								where a.plan_id =b.item_id AND b.branchcode=v_branchcode AND b.item_id=v_id
							  ) 
				ORDER BY rg_id DESC LIMIT 1),'');
		
			END IF ;
			
			IF(vchecking='')THEN
			
				SET vchecking=IFNULL((SELECT a.rg_id 
				FROM kqr_land_register_items as a 
				WHERE  EXISTS (
								SELECT b.item_id 
								FROM kqr_land_items as b 
								where a.street_id=b.item_id AND b.branchcode=v_branchcode AND b.item_id=v_id
							  ) 
				ORDER BY rg_id DESC LIMIT 1),'');
		
			END IF ;
		
			IF(vchecking='')THEN
			
				SET vchecking=IFNULL((SELECT a.rg_id 
				FROM kqr_land_register_items as a 
				WHERE  EXISTS (
								SELECT b.item_id 
								FROM kqr_land_items as b 
								where a.size_id=b.item_id AND b.branchcode=v_branchcode AND b.item_id=v_id
							  ) 
				ORDER BY rg_id DESC LIMIT 1),'');
		
			END IF ;
		
		
		IF(vchecking='')THEN
			
				SET vchecking=IFNULL((SELECT a.exp_id 
				FROM kqr_land_expend as a 
				WHERE  EXISTS (
								SELECT b.item_id 
								FROM kqr_land_items as b 
								where a.exp_type=b.item_id AND b.branchcode=v_branchcode AND b.item_id=v_id
							  ) 
				ORDER BY exp_id DESC LIMIT 1),'');
		
			END IF ;
		
			
			IF(vchecking<>'')THEN
			
				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;
			 
			END IF ;
	
	 ELSEIF v_status = 'land_items' THEN
			
	  		SET vchecking='';
		
			SET vchecking=IFNULL((SELECT a.rg_id 
			FROM kqr_land_register_items as a
			WHERE  EXISTS (
							SELECT b.cus_id 
							FROM kqr_land_sale as b 
							where a.rg_id=b.rg_id AND b.branchcode=v_branchcode AND b.rg_id=v_id
						  )
			ORDER BY rg_id DESC LIMIT 1),'');
			
			IF(vchecking<>'')THEN
			
				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;
			 
			END IF ;
	  ELSEIF v_status = 'land_customer' THEN
			
	  		SET vchecking='';
		
			SET vchecking=IFNULL((SELECT a.cus_id 
			FROM kqr_land_customers as a
			WHERE  EXISTS (
							SELECT b.cus_id 
							FROM kqr_land_sale as b 
							where a.cus_id =b.cus_id AND b.branchcode=v_branchcode AND b.cus_id=v_id
						  )
			ORDER BY a.cus_id DESC LIMIT 1),'');
		
			
			IF(vchecking<>'')THEN
			
				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;
			 
			END IF ;
	  ELSEIF v_status = 'delete_profile' THEN
	  		SET vchecking='';
	  
	  		SET vchecking=IFNULL((SELECT a.profile
			FROM gb_sys_users as a
			WHERE  EXISTS (
							SELECT b.profileid 
							FROM gb_profile_by_branch as b 
							where a.profile = b.profileid AND a.branchcode=b.branchcode  AND b.profileid=v_id
						  )
			ORDER BY a.profile DESC LIMIT 1),'');
		
			IF(vchecking<>'')THEN
			
				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;
			 
			END IF ;
	 ELSEIF v_status = 'land_sold' THEN
	  		SET vchecking='';
	  
	  		SET vchecking=IFNULL((SELECT a.rg_id 
			FROM kqr_land_register_items as a
			WHERE  EXISTS (
							SELECT b.rg_id 
							FROM kqr_land_sale as b 
							where a.rg_id = b.rg_id AND a.branchcode=b.branchcode  AND b.rg_id =v_id
						  )
			ORDER BY a.rg_id DESC LIMIT 1),'');
		
			IF(vchecking<>'')THEN
			
				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;
			 
			END IF ;
		ELSEIF v_status = 'income_exp' THEN
	  		SET vchecking='';
	  
	  		SET vchecking=IFNULL((SELECT a.exp_id FROM kqr_land_expend as a where a.branchcode =v_branchcode and a.exp_id = v_id and a.postreferent is not null ORDER BY a.exp_id DESC LIMIT 1),'');
		
			IF(vchecking<>'')THEN
			
				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;
			 
			END IF ;

  	  END IF;      
  	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_coffee_add_line` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(10), IN `v_line_name` VARCHAR(255), IN `v_type_line` VARCHAR(20), IN `v_inactive` VARCHAR(10), IN `v_inputter` VARCHAR(255))  begin
	
	DECLARE vsubm_id varchar(50);

	IF (v_status = 'I') then
		CALL gb_next_id_branch(v_branchcode,'coffee_line', '1', vsubm_id);
		insert into coffee_tbl_line (line_id, branchcode, line_name, inactive, line_type, inputter, inputdate) values (vsubm_id,v_branchcode,v_line_name,v_inactive,v_type_line,v_inputter,now());
	 ELSEIF (v_status = 'U') THEN
		update coffee_tbl_line  a 
		set a.line_name=v_line_name,
		    a.inactive=v_inactive,
		    a.line_type=v_type_line,
		    a.inputter=v_inputter
		where  a.branchcode =v_branchcode and a.line_id =v_code;
	end if ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_coffee_add_product` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(10), IN `v_token` VARCHAR(100), IN `v_inputter` VARCHAR(255), IN `v_barcode` VARCHAR(20), IN `v_name` VARCHAR(250), IN `v_inactive` VARCHAR(10), IN `v_type` VARCHAR(20), IN `v_line_size` VARCHAR(20), IN `v_cost` DECIMAL(13,4), IN `v_up` DECIMAL(13,4), IN `v_discount` DECIMAL(13,4), IN `v_coupon` DECIMAL(13,4), IN `v_subactive` VARCHAR(10))  begin
	
	DECLARE vsubm_id 	varchar(50);
	DECLARE vsysdocnum 	varchar(50);
	DECLARE vexsisting 	varchar(50);

	IF (v_status = 'I') THEN

		SET vexsisting= IFNULL((SELECT pro_id FROM coffee_tbl_products as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		IF (vexsisting='')THEN
			CALL gb_next_id_branch(v_branchcode,'coffee_item', '1', vsubm_id);
			CALL gb_next_id_branch(v_branchcode,'coffee_size', '9', vsysdocnum);
		
			SET v_code=vsubm_id;
			
			INSERT INTO coffee_tbl_products (pro_id, barcode, branchcode, pro_name, inactive, category, cost, unitprice, discount, currency,sys_token, inputter, inputdate)
						VALUES(v_code, v_barcode,v_branchcode, v_name, v_inactive, v_type, 0, 0, 0, '01',v_token, v_inputter, now());
		else
			SET v_code=vexsisting;
			CALL gb_next_id_branch(v_branchcode,'coffee_size', '9', vsysdocnum);
		END IF;
		
		INSERT INTO coffee_tbl_product_size (sysdocnum, pro_id, branchcode, sizecode, coupon, inactive, cost, unitprice, discount, inputter, inputdate)
				VALUES(vsysdocnum, v_code, v_branchcode, v_line_size, v_coupon, v_subactive, v_cost, v_up, v_discount, v_inputter, now());

	END IF;

	SELECT v_code AS trancode;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_coffee_sql` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(25), IN `v_condition2` VARCHAR(25))  begin
	
	IF (v_condition1='all')THEN 
		SET v_condition1='%';
	END IF ;

	if (v_status='coffee_list')then
		select distinct 
			   a.line_id ,
			   a.line_name,
			   a.inactive,
			   b.con_display as status,
			   a.line_type,
			   c.con_display as types,
			   a.inputter,
			   a.inputdate 
		from coffee_tbl_line a 
		left join gb_sys_contant_fix b on a.inactive=b.con_value and b.con_name ='inactive'
		left join gb_sys_contant_fix c on a.line_type =c.con_value and c.con_name ='coffee'
		where a.branchcode LIKE CONCAT(v_branchcode, '%') and a.line_id LIKE CONCAT(v_condition1, '%')
		order by a.line_type ,a.line_id ;
	elseif (v_status='category_active')then
		select a.line_id as id,
			   a.line_name as name 
		from coffee_tbl_line a 
		where a.branchcode LIKE CONCAT(v_branchcode, '%') and a.line_id LIKE CONCAT(v_condition1, '%') and a.line_type='01' and a.inactive='0'
		order by a.line_id ;
	elseif (v_status='coffee_item_list')then
		select distinct 
			a.pro_id ,
		 	a.barcode ,
		 	a.pro_name ,
		 	a.inactive ,
		 	a.category ,
		 	a.sys_token,
		 	b.line_name,
		 	c.con_display as status
		from coffee_tbl_products a
		inner join coffee_tbl_line b on a.branchcode =b.branchcode and a.category=b.line_id
		left join gb_sys_contant_fix c on a.inactive=c.con_value and c.con_name ='inactive'
		where a.branchcode LIKE CONCAT(v_branchcode, '%') and a.pro_id LIKE CONCAT(v_condition1, '%')
		order by a.pro_id ;
	elseif (v_status='coffee_item_size')then
		select distinct 
			   a.pro_id ,
			   a.pro_name,
			   a.category,
			   b.sizecode,
			   c.line_name as size_name,
			   b.cost,
			   b.unitprice,
			   b.discount,
			   b.coupon,
			   b.inactive,
			   ac.con_display as sub_status,
			   d.line_name as category 
		from coffee_tbl_products a 
		inner join coffee_tbl_product_size b on a.branchcode=b.branchcode and a.pro_id =b.pro_id 
		inner join coffee_tbl_line c on b.branchcode=c.branchcode and b.sizecode=c.line_id 
		inner join coffee_tbl_line d on a.branchcode =d.branchcode and a.category=d.line_id
		left join gb_sys_contant_fix ac on b.inactive=ac.con_value and ac.con_name ='inactive'
		where a.branchcode LIKE CONCAT(v_branchcode, '%') and a.pro_id LIKE CONCAT(v_condition1, '%')
		order by a.pro_id,b.sizecode ;
	end if ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_delete_trans` (IN `v_status` VARCHAR(25), IN `v_id` VARCHAR(255))  BEGIN

		IF v_status = 'menu' THEN
		
			DELETE a
			  FROM tbl_main_left_menu AS a
			WHERE a.menu_id = v_id;
		
		
		ELSEIF v_status = 'stock' THEN
			DELETE a
			  FROM kqr_pos_stock_menu AS a
			WHERE a.stk_id = v_id;
		ELSEIF v_status = 'sys_controls' THEN
			DELETE a
			  FROM gb_system_controls AS a
			WHERE a.sys_con_id = v_id;
		
		ELSEIF v_status = 'branch' THEN
			DELETE a
			  FROM kqr_sys_branch AS a
			WHERE a.branchcode = v_id;
		ELSEIF v_status = 'sys_permssion' THEN
			DELETE a
			  FROM kqr_sys_permission_menu AS a
			WHERE a.id = v_id;
		ELSEIF v_status = 'profile' THEN
			DELETE a
			  FROM kqr_sys_profile AS a
			WHERE a.pro_id = v_id;
		
		ELSEIF v_status = 'land_items' THEN
			DELETE a
			  FROM kqr_land_items AS a
			WHERE a.item_id = v_id;
		ELSEIF v_status = 'sub_menu' THEN
			DELETE a
			  FROM tbl_sub_left_menu AS a
			WHERE a.subm_id = v_id;
		ELSEIF v_status = 'system_control' THEN
			DELETE a
			  FROM gb_system_controls AS a
			WHERE a.sys_con_id = v_id;
		ELSEIF v_status = 'registerland' THEN
			DELETE a
			  FROM kqr_land_register_items AS a
			WHERE a.rg_id = v_id;
		ELSEIF v_status = 'customer_land' THEN
			DELETE a
			  FROM kqr_land_customers AS a
			WHERE a.cus_id = v_id;
		ELSEIF v_status = 'expend_land' THEN
			DELETE a
			  FROM kqr_land_expend AS a
			WHERE a.exp_id = v_id;
		
		ELSE
			SELECT
			  *
			FROM tbl_main_left_menu AS a
			WHERE a.menu_id = v_id;
		
		
		END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_delete_trans_by_branch` (IN `v_status` VARCHAR(25), IN `branchcode` VARCHAR(25), IN `v_id` VARCHAR(255))  BEGIN
IF v_status = 'land_items' THEN
    DELETE a
      FROM kqr_land_register_items AS a
      WHERE a.rg_id = v_id AND a.branchcode = branchcode;

  ELSEIF v_status = 'land_line' THEN

    DELETE a
      FROM kqr_land_items AS a
      WHERE a.item_id = v_id AND a.branchcode = branchcode;

  ELSEIF v_status = 'stock' THEN

    DELETE a
      FROM kqr_pos_stock_menu AS a
      WHERE a.stk_id = v_id AND a.branchcode = branchcode;

  ELSEIF v_status = 'land_sale' THEN

    IF NOT EXISTS ( SELECT A.sal_id FROM kqr_land_sale_act a WHERE a.sal_id = v_id AND a.branchcode = branchcode) THEN
       DELETE a
         FROM kqr_land_sale AS a WHERE a.sal_id = v_id  AND a.branchcode = branchcode;
    END IF;

  ELSEIF v_status = 'exp_tran' THEN
    
      DELETE a
         FROM kqr_land_expend AS a
         WHERE a.exp_id = v_id AND a.branchcode = branchcode;
  ELSEIF v_status = 'd_sale_land' THEN
    
      DELETE a
         FROM kqr_land_sale AS a
         WHERE a.sal_id = v_id AND a.branchcode = branchcode;

  ELSEIF v_status = 'd_land_line' THEN
    
      DELETE a
         FROM kqr_land_items AS a
         WHERE a.item_id = v_id AND a.branchcode = branchcode;
  ELSEIF v_status = 'delete_profile' THEN
    
      DELETE a
         FROM gb_profile_by_branch AS a
         WHERE a.profileid = v_id AND a.branchcode = branchcode;
 ELSEIF v_status = 'd_pos_line' THEN
    
      DELETE a
         FROM pos_tbl_proline AS a
         WHERE a.line_id = v_id AND a.branchcode = branchcode;
  ELSEIF v_status = 'd_pos_supply' THEN
  		DELETE a 
  		FROM pos_tbl_supplier as a 
  		where a.branchcode=branchcode and a.sup_id =v_id;
  ELSEIF v_status = 'd_pos_product' THEN
  		DELETE a 
  		FROM pos_tbl_products as a 
  		where a.branchcode=branchcode and a.pro_id =v_id;
  ELSEIF v_status = 'd_pos_purchase' THEN
  		
  		DELETE a 
  		FROM pos_tbl_una_purchase_order as a where a.branchcode =branchcode and a.pur_id =v_id;
  	
  		DELETE a 
  		FROM pos_tbl_una_purchase_details as a where a.branchcode =branchcode and a.pur_id =v_id;
   ELSEIF v_status = 'd_pos_customer' THEN
     		
  		DELETE a 
  		FROM pos_tbl_customers as a where a.branchcode =branchcode and a.cus_id =v_id;
   
   ELSEIF v_status = 'd_pos_invoice' THEN
   		DELETE a FROM pos_tbl_una_invoices as a WHERE a.branchcode =branchcode and a.inv_num =v_id;
   		DELETE a FROM pos_tbl_una_stockouts as a WHERE a.branchcode =branchcode and a.inv_num =v_id;
   		DELETE a FROM pos_tbl_fee as a WHERE a.branchcode =branchcode and a.inv_num =v_id;
   		
   	
   ELSEIF v_status = 'd_pos_stock_tf' THEN
    		DELETE a FROM pos_tbl_una_stocktransfer as a WHERE a.branchcode=branchcode and a.tran_code =v_id;
    		DELETE a from pos_tbl_una_stocktransfer_detail as a WHERE a.branchcode=branchcode and a.tran_code =v_id;
   ELSEIF v_status = 'd_pos_count_stock' THEN
    		DELETE a FROM pos_tbl_una_count_stock as a WHERE a.branchcode=branchcode and a.tran_code =v_id;
    		DELETE a from pos_tbl_una_count_stock_detail as a WHERE a.branchcode=branchcode and a.tran_code =v_id;
   ELSEIF v_status = 'd_pos_return_pos' THEN
   		DELETE a FROM pos_tbl_una_invoice_return as a WHERE a.branchcode =branchcode and a.inv_num =v_id;
   		DELETE a FROM pos_tbl_una_stockout_return as a WHERE a.branchcode =branchcode and a.inv_num =v_id;
   ELSEIF v_status = 'd_pos_expense' THEN
   		DELETE a FROM pos_tbl_una_expense as a WHERE a.branchcode=branchcode and a.tran_code=v_id;
   ELSEIF v_status = 'd_pos_income' THEN
   		DELETE a FROM pos_tbl_una_income as a WHERE a.branchcode=branchcode and a.tran_code=v_id;
   ELSEIF v_status = 'd_post_quote' then
   	DELETE a FROM post_tbl_quotes as a WHERE a.branchcode =branchcode and a.id =v_id;
   END IF;

   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_branch` (IN `v_subofbranch` VARCHAR(255), IN `v_branchcode` NVARCHAR(50))  BEGIN

SELECT
  a.branchcode,
  a.subofbranch,
  a.branchname,
  a.branchshort,
  a.inactive,
  a.phone,
  a.email,
  a.website
FROM kqr_sys_branch AS a
WHERE a.subofbranch LIKE CONCAT('%', v_subofbranch, '%')
AND a.branchcode LIKE CONCAT('%', v_branchcode, '%');

UPDATE kqr_sys_branch ksb
INNER JOIN kqr_sys_users ksu
  ON ksb.branchcode = ksu.branchcode
SET ksb.phone = ksu.contact
WHERE ksb.branchcode LIKE CONCAT('%', v_branchcode, '%')
AND ksb.phone IS NULL;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_main_menu` (IN `v_menuid` VARCHAR(255))  BEGIN

SELECT
  a.menu_id,
  a.menu_name,
  a.menu_effective_date,
  a.menu_inactive,
  a.menu_inputer,
  a.menu_glyphicon1,
  a.menu_glyphicon2,
  a.menu_glyphicon3,
  a.menu_class1,
  a.menu_class2,
  a.menu_class3
FROM tbl_main_left_menu AS a
WHERE a.menu_id LIKE CONCAT('%', v_menuid, '%');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_menu_by_user` (IN `v_status` VARCHAR(25), IN `v_user_id` VARCHAR(25), IN `v_gmail` VARCHAR(255), IN `v_current_menu` VARCHAR(255))  BEGIN

   DECLARE  vsupper 			varchar(50);
  DECLARE  v_user_profile 	varchar(50);
  DECLARE  vcurrent_menu_id varchar(50);
  DECLARE  vsub_menu_id 	varchar(50);

  SET vsupper = ( SELECT CASE WHEN u.supper = '1' THEN 'yes' ELSE 'no' END FROM gb_sys_users AS u WHERE u.id = v_user_id AND u.email = v_gmail ORDER by u.supper DESC LIMIT 1);
  SET vsub_menu_id= ifnull((SELECT subm_id FROM tbl_sub_left_menu as a where a.subm_function=v_current_menu ORDER by subm_id DESC LIMIT 1 ),'');
  SET vcurrent_menu_id= ifnull((SELECT menu_id FROM tbl_sub_left_menu as a where a.subm_id=vsub_menu_id ORDER by menu_id DESC LIMIT 1 ),'');
 
  SET v_user_profile = ( SELECT u.profile FROM gb_sys_users AS u WHERE u.id = v_user_id AND u.email = v_gmail ORDER by u.id DESC LIMIT 1);
 
 
  	IF (v_status = 'main'AND vsupper = 'yes') THEN

		SELECT
			  a.menu_id,
			  a.menu_name,
			  a.menu_inactive,
			  a.menu_glyphicon1,
			  a.menu_glyphicon2,
			  a.menu_glyphicon3,
			  a.menu_class1,
			  a.menu_class2,
			  a.menu_class3,
			  vcurrent_menu_id as current_menu_id,
			  vsupper as supper
		FROM tbl_main_left_menu AS a
		WHERE a.menu_inactive = '0'
		ORDER BY a.menu_order ,a.menu_id ;

  	ELSEIF (v_status = 'main' AND vsupper = 'no') THEN
  

		SELECT DISTINCT
			  u.id,
			  u.email as username,
			  m.systemid ,
			  m.menu_id,
			  b.menu_name,
			  b.menu_glyphicon1,
			  b.menu_glyphicon2,
			  b.menu_glyphicon3,
			  b.menu_class1,
			  b.menu_class2,
			  b.menu_class3,
			  vcurrent_menu_id as current_menu_id,
			  vsupper as supper,
			  v_user_profile,
			  b.menu_order
		FROM gb_sys_users AS u
		  INNER JOIN gb_system_controls as s on u.systemid=s.sys_con_id 
		  INNER JOIN gb_tbl_permission AS m ON u.systemid = m.systemid 
		  INNER JOIN tbl_main_left_menu AS b ON m.menu_id = b.menu_id
		WHERE b.menu_inactive = '0'  AND 
			  u.email = v_gmail   AND 
			  u.id=v_user_id AND 
			  m.views='1' AND 
			  m.pro_id =v_user_profile order by b.menu_order,m.systemid ;
 
	ELSEIF (v_status = 'sub' AND vsupper = 'yes') THEN
	
		SELECT
			  a.menu_id,
			  a.menu_name,
			  b.subm_id,
			  b.subm_name,
			  b.subm_function,
			  b.subm_glyphicon,
			  vcurrent_menu_id as current_menu_id,
			  vsub_menu_id as current_sub_id,
			  vsupper as supper
		FROM tbl_main_left_menu AS a
		  	INNER JOIN tbl_sub_left_menu AS b ON a.menu_id = b.menu_id
		  	WHERE a.menu_inactive = '0'
			ORDER BY b.subm_order,b.subm_name;


	ELSEIF (v_status = 'sub' AND vsupper = 'no') THEN
	
		SELECT DISTINCT
			  u.id,
			  m.systemid,
			  d.menu_id,
			  m.menu_id as subm_id ,
			  c.subm_name,
			  c.subm_function,
			  c.subm_glyphicon,
			  c.subm_order,
			  vcurrent_menu_id as current_menu_id,
			  vsub_menu_id as current_sub_id,
			  vsupper as supper,
			  d.menu_name as main_menu
		FROM gb_sys_users AS u
			  INNER JOIN gb_system_controls as s on u.systemid=s.sys_con_id 
			  INNER JOIN gb_tbl_permission AS m ON u.systemid = m.systemid 
			  INNER JOIN tbl_sub_left_menu AS c ON m.menu_id = c.subm_id
			  INNER JOIN tbl_main_left_menu as d on c.menu_id=d.menu_id 
			  
			  WHERE c.subm_inactive= '0' AND 
			  u.id = v_user_id AND 
			  u.email = v_gmail AND 
			  m.views='1' AND 
			  m.pro_id =v_user_profile
			  ORDER BY c.subm_order,c.subm_name  ;

	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_sql` (IN `v_status` VARCHAR(25), IN `v_tran1` VARCHAR(50))  BEGIN
   IF v_status = 'check_branch' THEN
	select a.setname ,
		   a.branchcode,
		   a.branchname,
		   a.branchshort,
		   a.subofbranch 
	from gb_sys_branch as a 
	where a.setname=v_tran1;	
ELSEIF v_status = 'inactive' THEN
	 select CONVERT(a.con_value , CHAR CHARACTER SET utf8)  as id ,
	 	    CONVERT(a.con_display , CHAR CHARACTER SET utf8)  as name
	from gb_sys_contant_fix a where a.con_name='inactive' order by a.con_value ;
	  
ELSEIF v_status = 'check_user' THEN
	select a.username ,
		   a.branchcode,
		   a.name,
		   a.contact,
		   a.supper,
		   b.sys_con_name,
		   b.sys_con_short_name as short_name
	from gb_sys_users as a 
	left join gb_system_controls as b on a.systemid=b.sys_con_id 
	where a.username=v_tran1;

 ELSEIF v_status = 'sub_menu' THEN
	select a.subm_id,
		   a. subm_name,
		   a.subm_controller,
		   a.subm_function ,
		   a.subm_inactive ,
		   case when  a.subm_inactive='1' THEN 'YES' ELSE 'NO' END as status,
		   a.subm_inputer ,
		   a.subm_order,
		   a.subm_glyphicon as sub_icon,
		   b.menu_id ,
		   b.menu_name 
	from tbl_sub_left_menu a 
	inner join tbl_main_left_menu b on a.menu_id=b.menu_id order by CONVERT(b.menu_id,SIGNED INTEGER),CONVERT(a.subm_order ,SIGNED INTEGER);

 ELSEIF v_status = 'list_main_menu' THEN
	select 
			menu_id as id ,
			menu_name as name 
	from tbl_main_left_menu a 
	where a.menu_inactive ='0';

 ELSEIF v_status = 'combo_province' THEN
	SELECT 	a.id ,
			a.eng_name  as name 
	FROM kqr_sys_address as a 
	where a.inactive='0';

 ELSEIF v_status = 'combo_system' THEN
 	SELECT '' AS id , 'Please system' AS name
 	union 
	SELECT a.sys_con_id as id,
		   a.sys_con_name  as name 
	FROM gb_system_controls as a 
	where a.sys_con_inactive='0';
ELSEIF v_status = 'combo_permission' then
 	SELECT '' AS id , 'Please choose' AS name
 	union 
	SELECT a.pro_id as id,
		   a.pro_name  as name 
	FROM gb_tbl_profile as a 
	where a.inactive='0' and a.systemid =v_tran1
	order by id ;
ELSEIF v_status = 'combo_currency' THEN
   
	select a.currencycode  as id,
		   a.currencyshort  as name 
	from gb_tbl_currency a 
	where a.inactive='0';

 ELSEIF v_status = 'load_sub_menu' THEN
 	
 	select a.subm_id,
		   a. subm_name,
		   a.subm_controller,
		   a.subm_function ,
		   a.subm_inactive ,
		   case when  a.subm_inactive='1' THEN 'YES' ELSE 'NO' END as status,
		   a.subm_inputer ,
		   a.subm_order,
		   a.subm_glyphicon as sub_icon,
		   b.menu_id ,
		   b.menu_name 
	from tbl_sub_left_menu a 
	inner join tbl_main_left_menu b on a.menu_id=b.menu_id 
	where a.subm_id=v_tran1
	order by a.subm_id ;	
ELSEIF v_status = 'admin_menu' THEN
	SELECT
	  a.menu_id,
	  a.menu_name,
      a.menu_effective_date,
      DATE_FORMAT(a.menu_effective_date, "%d- %M- %Y") as menu_effective,
	  a.menu_inactive,
      case when  a.menu_inactive='1' THEN 'YES' ELSE 'NO' END as status,
	  a.menu_inputer,
	  a.menu_glyphicon1,
	  a.menu_glyphicon2,
	  a.menu_glyphicon3,
	  a.menu_class1,
	  a.menu_class2,
	  a.menu_class3
	FROM tbl_main_left_menu AS a
	where  a.menu_id LIKE CONCAT(v_tran1, '%');

 ELSEIF v_status = 'system_controls' THEN
 
 	SELECT a.sys_con_id,
 		   a.sys_con_name ,
 		   a.sys_con_short_name,
 		   a.sys_con_effective ,
           DATE_FORMAT(a.sys_con_effective, "%y- %M- %d") as system_effective,
 		   a.sys_con_inactive ,
 		   a.sys_con_remark ,
 		   a.inputter ,
 		   case when  a.sys_con_inactive='1' THEN 'YES' ELSE 'NO' END as status
 	FROM gb_system_controls as a 
 	WHERE  a.sys_con_id LIKE CONCAT(v_tran1, '%');

  ELSEIF (v_status = 'combo_sub_menu') THEN
  	select A.subm_id  AS id,
  		   A.subm_name  AS name
  	FROM tbl_sub_left_menu AS A
  	where a.subm_inactive='0' and a.menu_id=v_tran1;
  ELSEIF (v_status = 'permission') THEN
  	
	  	drop temporary table if exists tmpmenu;
		
		create temporary table tmpmenu
		(
			menu_id varchar(45),
			menu_name varchar(500),
			main_id varchar(500),
			views	tinyint(4),
			booking tinyint(4),
			edit tinyint(4),
			deletes tinyint(4),
			status varchar(10)
		);
		
		insert into tmpmenu(menu_id,menu_name,main_id,views,booking,edit,deletes,status)
		SELECT CONVERT(a.menu_id , CHAR CHARACTER SET utf8) menu_id,
			   CONVERT(a.menu_name , CHAR CHARACTER SET utf8) menu_name,
			   CONVERT(a.menu_id , CHAR CHARACTER SET utf8) menu_id,
			   CASE when aa.views IS NOT NULL THEN '1' ELSE '0' END as views,
			   CASE when aa.booking IS NOT NULL THEN '1' ELSE '0' END as booking,
			   CASE when aa.edit IS NOT NULL THEN '1' ELSE '0' END as edit,
			   CASE when aa.deletes IS NOT NULL THEN '1' ELSE '0' END as deletes,
			   CONVERT('YES' , CHAR CHARACTER SET utf8) status
		FROM tbl_main_left_menu as a 
		LEFT JOIN  tbl_menu_permission as aa on a.menu_id=aa.menu_id and aa.menu_id='just show'
		where a.menu_inactive='0'
		union all
		select  CONVERT(b.subm_id, CHAR CHARACTER SET utf8) subm_id,
				CONVERT(b.subm_name, CHAR CHARACTER SET utf8) subm_name,
				CONVERT(b.menu_id, CHAR CHARACTER SET utf8) menu_id,
				CASE when bb.views IS NOT NULL THEN '1' ELSE '0' END as views,
				CASE when bb.booking IS NOT NULL THEN '1' ELSE '0' END as booking,
				CASE when bb.edit IS NOT NULL THEN '1' ELSE '0' END as edit,
				CASE when bb.deletes IS NOT NULL THEN '1' ELSE '0' END as deletes,
				CONVERT('NO' , CHAR CHARACTER SET utf8) status
		FROM  tbl_sub_left_menu as b 
		inner join tbl_main_left_menu as c on b.menu_id=c.menu_id 
		LEFT JOIN  tbl_menu_permission as bb on b.subm_id=bb.menu_id and bb.menu_id='just show'
		WHERE c.menu_inactive='0' ;
	
	  	
		SELECT * from tmpmenu as a order by a.main_id,a.menu_id;
 ELSEIF (v_status = 'permission_list') THEN
 	
 	SELECT A.per_id,
 		   A.menu_id,
 		   A.views,
 		   A.booking,
 		   A.edit,
 		   A.deletes,
 		   A.keytoken 
 	FROM tbl_menu_permission AS A WHERE A.systemid=v_tran1;
 ELSEIF v_status = 'reportname' THEN
 	
 	SELECT a.subm_id ,
 		   a.menu_id ,
 		   a.subm_controller ,
 		   a.subm_function ,
 		   a.subm_name as reportname
 	FROM tbl_sub_left_menu as a 
 	WHERE a.subm_function=v_tran1 ORDER BY a.subm_id LIMIT 1  ;
 ELSEIF (v_status = 'setup_permission') then
 	drop temporary table if exists tmpmenu;
	create temporary table tmpmenu
	(
		menu_id varchar(45),
		menu_name varchar(500),
		main_id varchar(500),
		views	tinyint(4),
		booking tinyint(4),
		edit tinyint(4),
		deletes tinyint(4),
		status varchar(10)
	);

	
		insert into tmpmenu(menu_id,menu_name,main_id,views,booking,edit,deletes,status)
		SELECT CONVERT(a.menu_id , CHAR CHARACTER SET utf8) menu_id,
			   CONVERT(a.menu_name , CHAR CHARACTER SET utf8) menu_name,
			   CONVERT(a.menu_id , CHAR CHARACTER SET utf8) menu_id,
			   aa.views,
			   aa.booking ,
			   aa.edit,
			   aa.deletes,
			   CONVERT('YES' , CHAR CHARACTER SET utf8) status
		FROM tbl_main_left_menu as a 
		LEFT JOIN  tbl_menu_permission as aa on a.menu_id=aa.menu_id 
		where a.menu_inactive='0' and aa.systemid =v_tran1 and aa.views='1'
		union all
		select  CONVERT(b.subm_id, CHAR CHARACTER SET utf8) subm_id,
				CONVERT(b.subm_name, CHAR CHARACTER SET utf8) subm_name,
				CONVERT(b.menu_id, CHAR CHARACTER SET utf8) menu_id,
				bb.views,
				bb.booking,
				bb.edit,
				bb.deletes,
				CONVERT('NO' , CHAR CHARACTER SET utf8) status
		FROM  tbl_sub_left_menu as b 
		inner join tbl_main_left_menu as c on b.menu_id=c.menu_id 
		LEFT JOIN  tbl_menu_permission as bb on b.subm_id=bb.menu_id 
		WHERE c.menu_inactive='0' and bb.systemid =v_tran1 and bb.views='1';
	
  	
	SELECT distinct * from tmpmenu as a order by a.main_id,a.menu_id;
 ELSEIF (v_status = 'user_image') then
	
 	select * 
 	from gb_sys_users a 
 	inner join gb_sys_user_info b on a.id=b.id 
 	where a.id=v_tran1
 	limit 1;

 END IF;                                                                

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_sql_by_branch` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(25), IN `v_condition2` VARCHAR(25))  BEGIN
 DECLARE v_systemid 	varchar(50);
	 DECLARE v_supperuser 	varchar(50);

	 set v_systemid=ifnull((select a.systemid from gb_sys_users a where a.branchcode=v_branchcode order by a.branchcode limit  1 ),'');
	 set v_supperuser=ifnull((SELECT case when  u.supper ='1' THEN 'YES' ELSE 'NO' END FROM gb_sys_users u WHERE u.branchcode=v_branchcode and u.id=v_condition1 and u.supper='1' order by u.branchcode limit 1),'');

	 IF v_status = 'branch' THEN
		IF (v_supperuser='YES') THEN

			SELECT b.branchcode,
				   b.subofbranch,
				   b.branchname,
				   IFNULL(b.branchshort,'') as branchshort,
				   case when  b.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
				   b.setname ,
				   b.phone,
				   b.email,
				   b.website,
				   b.country,
				   b.address 
			FROM gb_sys_branch b ;
		ELSE
			SELECT b.branchcode,
				   b.subofbranch,
				   b.branchname,
				   IFNULL(b.branchshort,'') as branchshort,
				   case when  b.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
				   b.setname ,
				   b.phone,
				   b.email,
				   b.website,
				   b.country,
				   b.address 
			FROM gb_sys_branch b
			WHERE b.branchcode LIKE CONCAT(v_branchcode, '%') or b.subofbranch LIKE CONCAT(v_condition2, '%') and 
			b.branchcode<>b.subofbranch order by branchcode ;

		END IF;
	 ELSEIF v_status = 'getbranch' THEN
			SELECT b.branchcode as id,
			 	   b.branchname as name,
				   b.branchcode,
				   b.subofbranch,
				   b.branchname,
				   IFNULL(b.branchshort,'') as branchshort,
				   case when  b.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
				   b.inactive,
				   b.setname ,
				   b.phone,
				   b.email,
				   b.website,
				   b.country,
				   b.address 
			FROM gb_sys_branch b
			WHERE ( b.branchcode LIKE CONCAT(v_branchcode, '%') or b.subofbranch LIKE CONCAT(v_condition2, '%'))
					and b.branchcode<>b.subofbranch order by branchcode ;
	ELSEIF v_status = 'edit_getbranch' THEN
			SELECT b.branchcode as id,
			 	   b.branchname as name,
				   b.branchcode,
				   b.subofbranch,
				   b.branchname,
				   IFNULL(b.branchshort,'') as branchshort,
				   case when  b.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
				   b.inactive,
				   b.setname ,
				   b.phone,
				   b.email,
				   b.website,
				   b.country,
				   b.address 
			FROM gb_sys_branch b
			WHERE b.branchcode LIKE CONCAT(v_branchcode, '%');
    ELSEIF v_status = 'getprofile' THEN
    	IF EXISTS(SELECT u.branchcode FROM gb_sys_users u WHERE u.branchcode=v_branchcode and u.id=v_condition1 and u.supper='1') THEN
	 	    SELECT p.profileid ,
	 	    	   p.branchcode ,
	 	    	   b.setname,
	 	    	   b.branchname ,
	 	    	   p.profilename,
	 	    	   p.inactive,
	 	    	   case when  p.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
	 	    	   p.inputter
	 	    FROM gb_profile_by_branch p
	 	    INNER JOIN gb_sys_branch b on p.branchcode =b.branchcode ;
	   ELSE
	 	    SELECT p.profileid ,
	 	    	   p.branchcode ,
	 	    	   b.setname,
	 	    	   b.branchname ,
	 	    	   p.profilename,
	 	    	   p.inactive,
	 	    	   case when  p.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
	 	    	   p.inputter
	 	    FROM gb_profile_by_branch p
	 	    INNER JOIN gb_sys_branch b on p.branchcode =b.branchcode
	 	    WHERE p.branchcode LIKE CONCAT(v_branchcode, '%');

	   END IF;
	ELSEIF v_status = 'profile_active' THEN
  	 	SELECT p.profileid  as id,
  	 		   p.profilename as name,
  	 		   p.profileid ,
 	    	   p.branchcode ,
 	    	   b.setname,
 	    	   b.branchname ,
 	    	   p.profilename,
 	    	   p.inactive,
 	    	   case when  p.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
 	    	   p.inputter
    	FROM gb_profile_by_branch p
    	INNER JOIN gb_sys_branch b on p.branchcode =b.branchcode
    	WHERE p.branchcode LIKE CONCAT(v_branchcode, '%') and p.inactive='0';
    ELSEIF v_status = 'profile' then
    	IF (v_supperuser='YES') THEN
	    	select distinct
	    		   a.pro_id as id ,
	    		   a.pro_name as name ,
	    		   a.systemid
	    	from gb_tbl_profile a
	    	where a.inactive='0'
	    	order by a.pro_id ;
    	ELSE
	    	select distinct
	    		   a.pro_id as id ,
	    		   a.pro_name as name ,
	    		   a.systemid
	    	from gb_tbl_profile a
	    	where a.inactive='0' and a.systemid=v_systemid
	    	order by a.pro_id ;
	    END IF;
	ELSEIF v_status = 'setup_profile' THEN

	 		SELECT p.profileid ,
	 	    	   p.branchcode ,
	 	    	   b.setname,
	 	    	   b.branchname ,
	 	    	   p.profilename,
	 	    	   p.inactive,
	 	    	   case when  p.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
	 	    	   p.inputter
	 	    FROM gb_profile_by_branch p
	 	    INNER JOIN gb_sys_branch b on p.branchcode =b.branchcode
	 	    WHERE p.branchcode LIKE CONCAT(v_branchcode,'%') and p.profileid=v_condition1;

	ELSEIF v_status = 'setup_user' THEN

			SELECT a.id,
				   a.name,
				   a.branchcode ,
				   a.subofbranch ,
				   a.email as username,
				   a.contact,
				   a.profile,
				   b.pro_name as profilename,
				   a.supper,
				   a.Inactive as inactive,
				   case when  a.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
				   a.systemid,
				   c.sys_con_name ,
				   a.inputter,
				   d.branchname ,
				   d.branchshort 
			FROM gb_sys_users a
			INNER JOIN gb_tbl_profile as b on a.profile=b.pro_id
			INNER JOIN  gb_system_controls as c on a.systemid =c.sys_con_id
			inner join gb_sys_branch d on a.branchcode=d.branchcode 
			WHERE (a.branchcode LIKE CONCAT(v_branchcode,'%') or  a.subofbranch LIKE CONCAT(v_condition2, '%') ) and a.id LIKE CONCAT(v_condition1,'%') order by a.branchcode ,a.profile ;
	ELSEIF v_status ='branchpermission' THEN

		drop temporary table if exists tmp_menu;

		create temporary table tmp_menu
		(
			menu_id varchar(45),
			menu_name varchar(500),
			main_id varchar(500),
			views	tinyint(4),
			booking tinyint(4),
			edit tinyint(4),
			deletes tinyint(4),
			status varchar(10)
		);

		insert into tmp_menu(menu_id,menu_name,main_id,views,booking,edit,deletes,status)
		SELECT CONVERT(a.menu_id , CHAR CHARACTER SET utf8) menu_id,
			   CONVERT(a.menu_name , CHAR CHARACTER SET utf8) menu_name,
			   CONVERT(a.menu_id , CHAR CHARACTER SET utf8) menu_id,
			   CASE when aa.views IS NOT NULL THEN '1' ELSE '0' END as views,
			   CASE when aa.booking IS NOT NULL THEN '1' ELSE '0' END as booking,
			   CASE when aa.edit IS NOT NULL THEN '1' ELSE '0' END as edit,
			   CASE when aa.deletes IS NOT NULL THEN '1' ELSE '0' END as deletes,
			   CONVERT('YES' , CHAR CHARACTER SET utf8) status
		FROM tbl_main_left_menu as a
		INNER JOIN  tbl_menu_permission as aa on a.menu_id=aa.menu_id and aa.systemid=v_condition1 and aa.views='1'
		where a.menu_inactive='0' and aa.systemid LIKE CONCAT(v_condition1,'%')
		union all
		select  CONVERT(b.subm_id, CHAR CHARACTER SET utf8) subm_id,
				CONVERT(b.subm_name, CHAR CHARACTER SET utf8) subm_name,
				CONVERT(b.menu_id, CHAR CHARACTER SET utf8) menu_id,
				CASE when bb.views IS NOT NULL THEN '1' ELSE '0' END as views,
				CASE when bb.booking IS NOT NULL THEN '1' ELSE '0' END as booking,
				CASE when bb.edit IS NOT NULL THEN '1' ELSE '0' END as edit,
				CASE when bb.deletes IS NOT NULL THEN '1' ELSE '0' END as deletes,
				CONVERT('NO' , CHAR CHARACTER SET utf8) status
		FROM  tbl_sub_left_menu as b
		INNER join tbl_main_left_menu as c on b.menu_id=c.menu_id
		INNER JOIN  tbl_menu_permission as bb on b.subm_id =bb.menu_id and bb.systemid=v_condition1 and bb.views='1'
		WHERE c.menu_inactive='0' and bb.systemid LIKE CONCAT(v_condition1,'%')  and bb.views='1';

		SELECT * from tmp_menu as a order by a.main_id,a.menu_id;

	ELSEIF v_status ='permission_by_branch' THEN

	 	SELECT a.per_id,
 		   a.menu_id,
 		   a.views,
 		   a.booking,
 		   a.edit,
 		   a.deletes,
 		   a.keytoken
 		FROM tbl_menu_permission_branch AS a WHERE a.profile_id =v_condition1 and a.branchcode  LIKE CONCAT(v_branchcode,'%');

	END IF ;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_sql_land` (IN `v_status` VARCHAR(25), IN `v_id` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_item_type` VARCHAR(25))  BEGIN
  DECLARE vsubm_id varchar(50);
  DECLARE v_type varchar(50);


  IF (v_item_type = 'Type') THEN
    SET v_type = '0';
  ELSEIF (v_item_type = 'Size') THEN
    SET v_type = '1';
  ELSEIF (v_item_type = 'Street') THEN
    SET v_type = '2';
  ELSEIF (v_item_type = 'Plan') THEN
    SET v_type = '3';
 ELSEIF (v_item_type = 'Expend') THEN
    SET v_type = '4';
  ELSE
    SET v_type = '';
  END IF;
 
 IF v_status = 'combo_land_line' THEN
	
	SELECT
	  kli.item_id as id ,
	  kli.item_name as name
	FROM kqr_land_items kli
	WHERE kli.item_id LIKE CONCAT('%', v_id, '%')
	AND kli.item_type LIKE CONCAT('%', v_type, '%')
	AND kli.branchcode = v_branchcode;
  ELSEIF v_status = 'combo_cus_land' THEN
 	
 	SELECT a.cus_id as id ,
 	       a.cus_nameeng  as name
 	FROM kqr_land_customers as a 
 	where a.branchcode=v_branchcode AND a.cus_id LIKE CONCAT('%', v_id, '%');
  ELSEIF v_status = 'land_percentage' THEN
    	SELECT CONVERT('' , CHAR CHARACTER SET utf8)  as id ,CONVERT('' , CHAR CHARACTER SET utf8)  as name  FROM dual
	  	union
  		SELECT 
  			klc.con_value  as id ,
  			klc.con_name as name 
  			
  		FROM kqr_land_constant klc where klc.con_type ='land_percentage';
   ELSEIF v_status = 'list_land_sale' THEN
  	
  		SELECT a.rg_id as id,
  			   a .rg_name as name,
  			   a.unitprice 
  		FROM kqr_land_register_items a
  		WHERE a.rg_id LIKE CONCAT('%', v_id, '%')  
  		      AND a.branchcode=v_branchcode;
  		     
  ELSEIF v_status = 'land_sale' THEN
  	
  		SELECT b.sal_id as id,
  		  	   a.rg_id ,
  			   a .rg_name as name,
  			   b.cost,
  			   b.discount,
  			   b.unitprice,
  			   b.amount ,
  			   b.cus_id ,
  			   b.remark,
  			   cc.currencyshort,
  			   c.cus_nameeng  as cus_name,
  			   c.cus_phone ,
  			   s.item_name as item_size,
  			   t.item_name as item_type,
  			   p.item_name as item_plan,
  			   st.item_name as item_street
  		FROM kqr_land_register_items a
  		inner join gb_tbl_currency cc on a.currency=cc.currencycode 
  		inner join kqr_land_sale b on a.rg_id=b.rg_id 
  		INNER JOIN kqr_land_customers c on b.cus_id =c.cus_id
  		INNER JOIN kqr_land_items s on a.size_id =s.item_id
  		INNER JOIN kqr_land_items t on a.type_id =t.item_id
  		INNER JOIN kqr_land_items p on a.plan_id =p.item_id
  		INNER JOIN kqr_land_items st on a.street_id =st.item_id
  		WHERE b.sal_id LIKE CONCAT('%', v_id, '%')  
  		      AND b.branchcode=v_branchcode;
  		     
  ELSEIF (v_status = 'E.Plan' or v_status = 'I.Plan') THEN
      SELECT
        A.item_id AS id,
        A.item_name AS name
      FROM kqr_land_items AS A
      WHERE A.item_type = '3'
      AND A.item_inactive = '0'
      AND A.branchcode = v_branchcode;
  ELSEIF (v_status = 'E.Land' or v_status = 'I.Land') THEN
      SELECT
        A.rg_id AS id,
        A.rg_name AS name
      FROM kqr_land_register_items AS A
      WHERE A.inactive = '0'
      AND A.branchcode = v_branchcode;
  ELSEIF (v_status = 'expend') THEN
      SELECT
        A.item_id AS id,
        A.item_name AS name
      FROM kqr_land_items AS A
      WHERE A.item_type = '4'
      AND A.item_inactive = '0'
      AND A.branchcode = v_branchcode;
  ELSEIF (v_status = 'income') THEN
      SELECT
        A.item_id AS id,
        A.item_name AS name
      FROM kqr_land_items AS A
      WHERE A.item_type = '5'
      AND A.item_inactive = '0'
      AND A.branchcode = v_branchcode;

  END IF;                             

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_sql_land_payments` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(25), IN `v_condition2` VARCHAR(25))  BEGIN
	 IF v_status = 'tiller' THEN
	 
		 SELECT a.exp_id ,
		   a.branchcode ,
		   a.exp_type,
		   c.item_name,
		   a.exp_referent ,
		   b.currencyshort as currency,
		   (a.exp_unitprice * c.c_method) as amount,
		   c.c_method,
		   c.item_type,
		   a.exp_remark,
		   a.inputter ,
		   Date_Format(a.exp_date,'%d/%m/%y') as exp_date
		FROM kqr_land_expend as a 
		inner join gb_tbl_currency as b on a.exp_currency=b.currencycode
		inner join  kqr_land_items as c on a.exp_type =c.item_id
		WHERE a.postreferent is NULL and a.branchcode LIKE CONCAT(v_branchcode, '%')
		order by c.item_type,a.exp_date ;

	 END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_sql_multi` (IN `v_status` VARCHAR(25), IN `v_con1` VARCHAR(50), IN `v_con2` VARCHAR(50), IN `v_con3` VARCHAR(50))  begin
	
	if v_status = 'setup_permission' then
		
		drop temporary table if exists tmppermission;
		create temporary table tmppermission
		(
			menu_id 	varchar(45),
			pro_id 		varchar(50),
			systemid 	varchar(50),
			menu_name 	varchar(250),
			views		tinyint(4),
			booking 	tinyint(4),
			edit 		tinyint(4),
			deletes 	tinyint(4),
			status 		varchar(10)
		);
		
		select a.per_id ,
			   a.menu_id,
			   a.pro_id ,
			   a.systemid ,
			   case when  a.views='1' THEN 'YES' ELSE 'NO' END as views,
			   case when  a.booking='1' THEN 'YES' ELSE 'NO' END as booking,
			   case when  a.edit='1' THEN 'YES' ELSE 'NO' END as edit,
			   case when  a.deletes='1' THEN 'YES' ELSE 'NO' END as deletes
		from gb_tbl_permission as a
		where a.systemid LIKE CONCAT(v_con1, '%') and a.pro_id  LIKE CONCAT(v_con2, '%');
	elseif v_status = 'userprofile' then
		
		select a.id,
			   a.email ,
			   a.name ,
			   a.contact ,
			   a.supper,
			   a.profile,
			   ifnull(b.pro_name,'N/A') as  pro_name,
			   ifnull(c.bio,'N/A') as  bio,
			   ifnull(c.gender,'N/A') as  gender,
			   ifnull(c.photo,'N/A') as  photo
		from gb_sys_users a
		left join gb_tbl_profile b 	 on a.profile =b.pro_id 
 		left join gb_sys_user_info c on  a.id=c.id
		where a.branchcode=v_con1 and a.id=v_con2 limit 1;
		
	end if ;
	
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_sub_menu` (IN `v_menuid` VARCHAR(255), IN `v_subm_id` VARCHAR(255))  BEGIN

SELECT
  a.subm_id,
  a.menu_id,
  a.subm_name,
  a.subm_function,
  a.subm_inactive
FROM tbl_sub_left_menu AS a
WHERE a.menu_id LIKE CONCAT('%', v_menuid, '%')
AND a.subm_id LIKE CONCAT('%', v_subm_id, '%');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_system_controls` (IN `v_menuid` VARCHAR(255))  BEGIN

SELECT
  ksc.sys_con_id,
  ksc.sys_con_name,
  ksc.sys_con_inactive,
  ksc.sys_con_short_name,
  ksc.sys_con_effective,
  ksc.sys_con_remark,
  ksc.sys_con_trandate
FROM kqr_system_controls ksc
WHERE ksc.sys_con_id LIKE CONCAT('%', v_menuid, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_get_system_profile` (IN `v_menuid` VARCHAR(255))  BEGIN

SELECT
  ksp.pro_id,
  ksp.pro_name,
  ksc.sys_con_name,
  ksp.sys_con_id,
  ksp.pro_effective,
  ksp.pro_inactive,
  ksp.pro_date,
  ksp.pro_inputer
FROM kqr_sys_profile ksp
  INNER JOIN kqr_system_controls ksc
    ON ksc.sys_con_id = ksp.sys_con_id
WHERE ksp.pro_id LIKE CONCAT('%', v_menuid, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_kqr_add_sub_menu` (IN `v_status` VARCHAR(25), IN `v_id` VARCHAR(25), IN `v_menuid` VARCHAR(255), IN `v_name` VARCHAR(255), IN `v_function` VARCHAR(255), IN `v_inactive` VARCHAR(255), IN `v_inputter` VARCHAR(255), IN `v_icon` VARCHAR(255), IN `v_effect_date` DATE)  BEGIN
  DECLARE vsubm_id varchar(50);


  	SET vsubm_id = ( SELECT
    MAX(subm_id) + 1 AS subm_id
  	FROM tbl_sub_left_menu);

	INSERT INTO tbl_sub_left_menu (subm_id, menu_id, subm_name, subm_function, subm_inactive, subm_inputer, subm_glyphicon, subm_effective_date)
  	VALUES (vsubm_id, v_menuid, v_name, v_function, v_inactive, v_inputter, v_icon, v_effect_date);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_add_customers` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(255), IN `v_cus_name` VARCHAR(255), IN `v_cus_gender` VARCHAR(255), IN `v_cus_inactive` VARCHAR(5), IN `v_cus_phone` VARCHAR(255), IN `v_cus_email` VARCHAR(255), IN `v_cus_address` VARCHAR(255), IN `v_remark` VARCHAR(255), IN `v_inputer` VARCHAR(255))  BEGIN

  	DECLARE vsubm_id varchar(50);


  	IF (v_status = 'i') THEN

		CALL gb_next_id_branch(v_branchcode,'land_customer', '1', vsubm_id);

		INSERT INTO kqr_land_customers (cus_id, branchcode, cus_namekh, cus_nameeng, cus_gender, cus_inactive, cus_email, cus_phone, cus_address, cus_remark, cus_inputer, cus_trandate)
		  VALUES (vsubm_id, v_branchcode, v_cus_name, v_cus_name, v_cus_gender, v_cus_inactive, v_cus_email, v_cus_phone, v_cus_address, v_remark, v_inputer, NOW());

	ELSE

		UPDATE kqr_land_customers ksb
		SET ksb.cus_namekh = v_cus_name,
		    ksb.cus_nameeng = v_cus_name,
		    ksb.cus_gender = v_cus_gender,
		    ksb.cus_email = v_cus_email,
		    ksb.cus_phone = v_cus_phone,
		    ksb.cus_address = v_cus_address,
		    ksb.cus_remark = v_remark,
		    ksb.cus_inactive = v_cus_inactive
		
		WHERE ksb.branchcode = v_branchcode
		AND ksb.cus_id = v_code;

	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_add_expend` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_exp_type` VARCHAR(25), IN `v_referent` VARCHAR(25), IN `v_exp_currency` VARCHAR(25), IN `v_unitprice` DECIMAL(13,4), IN `v_remark` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
   	DECLARE vsubm_id varchar(50);
  	DECLARE v_type varchar(50);
 
  	IF (v_status = 'I') THEN

	    CALL gb_next_id_branch(v_branchcode,'expend_code', '1', vsubm_id);
	   
	    INSERT INTO kqr_land_expend (exp_id,branchcode,exp_type,exp_referent,exp_currency,exp_unitprice,exp_remark,exp_inputer,exp_date) 
	                         VALUES (vsubm_id,v_branchcode,v_exp_type,v_referent,v_exp_currency,v_unitprice,v_remark,v_inputter,NOW());
	  
 	END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_add_items` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(255), IN `v_branchcode` VARCHAR(25), IN `v_item_name` VARCHAR(255), IN `v_item_type` VARCHAR(25), IN `v_inactive` VARCHAR(2), IN `v_remark` VARCHAR(255), IN `v_location` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
 
  DECLARE vsubm_id varchar(50);
  DECLARE v_type varchar(50);
  DECLARE v_method float;
  
  SET v_method=1;

  IF (v_item_type = 'Type') THEN
    SET v_type = '0';
  ELSEIF (v_item_type = 'Size') THEN
    SET v_type = '1';
  ELSEIF (v_item_type = 'Street') THEN
    SET v_type = '2';
  ELSEIF (v_item_type = 'Plan') THEN
    SET v_type = '3';
  ELSEIF (v_item_type = 'Expend') THEN
    SET v_method=-1;
    SET v_type = '4';
  ELSEIF (v_item_type = 'Income') THEN
    SET v_type = '5';
  ELSE
    SET v_type = '9';
  END IF;

  IF (v_status = 'I') THEN

	CALL gb_next_id_branch(v_branchcode,'items_code', '1', vsubm_id);


		INSERT INTO kqr_land_items (item_id, branchcode, item_name, item_type, item_inactive, item_remark, inputter , item_date,item_location,c_method)
		  VALUES (vsubm_id, v_branchcode, v_item_name, v_type, v_inactive, v_remark, v_inputter, NOW(),v_location,v_method);

   ELSE

		UPDATE kqr_land_items ksb
		SET ksb.item_name = v_item_name,
		    ksb.item_inactive = v_inactive,
		    ksb.item_remark = v_remark,
		    ksb.item_location=v_location,
		    ksb.c_method=v_method
		
		WHERE ksb.branchcode = v_branchcode
		AND ksb.item_id = v_code;

	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_get_customers` (IN `v_id` VARCHAR(25), IN `v_branchcode` VARCHAR(25))  BEGIN
  SELECT
  ksp.cus_id,
  ksp.branchcode,
  ksp.cus_nameeng,
  ksp.cus_namekh,
  ksp.cus_gender,
  CASE WHEN ksp.cus_gender = '1' THEN 'Male' ELSE 'Female' END AS v_gender,
  ksp.cus_inactive,
  CASE WHEN ksp.cus_inactive = '1' THEN 'yes' ELSE 'no' END AS v_inactive,
  ksp.cus_email,
  ksp.cus_phone,
  ksp.cus_address,
  ksp.cus_remark,
  ksp.inputter

FROM kqr_land_customers ksp

WHERE ksp.cus_id LIKE CONCAT('%', v_id, '%')
AND ksp.branchcode LIKE CONCAT('%', v_branchcode, '%')
ORDER BY ksp.cus_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_get_list_combo` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25))  BEGIN

  IF (v_status = 'E.Plan') THEN
SELECT
  A.item_id AS CODE,
  A.item_name AS NAME
FROM kqr_land_items AS A
WHERE A.item_type = '0'
AND A.item_inactive = '0'
AND A.branchcode = v_branchcode;
ELSEIF (v_status = 'E.Land') THEN
SELECT
  A.rg_id AS CODE,
  A.rg_name AS NAME
FROM kqr_land_register_items AS A
WHERE A.inactive = '0'
AND A.branchcode = v_branchcode;
ELSEIF (v_status = 'E.Other') THEN
SELECT
  '01' AS CODE,
  'Other' AS NAME
FROM dual
UNION ALL
SELECT
  '02' AS CODE,
  'Lost money' AS NAME
FROM dual;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_get_percent` (IN `v_status` VARCHAR(25))  BEGIN

  IF (v_status = 'land') THEN
SELECT
  glp.percent,
  glp.percent_name
FROM gb_list_percent glp
WHERE glp.type = v_status;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_get_register_items` (IN `v_id` VARCHAR(25), IN `v_branchcode` VARCHAR(25))  BEGIN
 SELECT
		  ksp.rg_id,
		  ksp.branchcode,
		  ksp.rg_name,
		  ksp.inactive,
		  ksp.currency,
		  c.currencyshort,
		  IFNULL(ksp.p_view, '0') AS p_view,
		  CASE WHEN ksp.inactive = '1' THEN 'yes' ELSE 'no' END AS v_inactive,
		  ksp.plan_id,
		  ksp.type_id,
		  ksp.size_id,
		  ksp.street_id,
		  ksp.cost,
		  ksp.unitprice,
		  ksc.item_name AS plan,
		  ksc1.item_name AS type,
		  ksc2.item_name AS size,
		  ksc3.item_name AS street,
		  ksp.remark,
		  ksp.inputter 
	FROM kqr_land_register_items ksp
	inner join gb_tbl_currency c on c.currencycode=ksp.currency 
	  LEFT JOIN kqr_land_items ksc
	    ON ksc.item_id = ksp.plan_id
	    AND ksc.branchcode = ksp.branchcode
	  LEFT JOIN kqr_land_items ksc1
	    ON ksc1.item_id = ksp.type_id
	    AND ksc1.branchcode = ksp.branchcode
	  LEFT JOIN kqr_land_items ksc2
	    ON ksc2.item_id = ksp.size_id
	    AND ksc2.branchcode = ksp.branchcode
	  LEFT JOIN kqr_land_items ksc3
	    ON ksc3.item_id = ksp.street_id
	    AND ksc3.branchcode = ksp.branchcode
	WHERE ksp.rg_id LIKE CONCAT('%', v_id, '%')
	AND ksp.branchcode LIKE CONCAT('%', v_branchcode, '%')
	ORDER BY ksp.rg_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_get_sale` (IN `v_id` VARCHAR(25), IN `v_branchcode` VARCHAR(25))  BEGIN
 SELECT
  kls.sal_id,
  kls.cus_id,
  kls.rg_id,
  kls.branchcode,
  kls.rg_name,
  klc.cus_nameeng AS customer,
  kls.cost,
  kls.unitprice,
  CONCAT_WS(' %', IFNULL(kls.discount, 0), '') AS discount,
  kls.amount,
  kls.inputter 
FROM kqr_land_sale kls
  INNER JOIN kqr_land_customers klc
    ON kls.cus_id = klc.cus_id
    AND kls.branchcode = klc.branchcode
WHERE kls.branchcode = v_branchcode
AND kls.sal_id LIKE CONCAT('%', v_id, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_get_sold` (IN `v_items_id` VARCHAR(25), IN `v_branchcode` VARCHAR(25))  BEGIN

SELECT
  a.rg_id
FROM kqr_land_sale AS a
WHERE a.rg_id = v_items_id
AND branchcode = v_branchcode;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_load_expend` (IN `v_id` VARCHAR(255), IN `v_branchcode` VARCHAR(255), IN `v_item_type` VARCHAR(255))  BEGIN
  DECLARE vsubm_id varchar(50);
  DECLARE v_type varchar(50);
	
 	IF (v_item_type='expend')THEN 
 		SET v_type ='4';
 	ELSEIF v_item_type = 'income' THEN
 		SET v_type ='5';
 	END IF;
 	
 	SELECT a.exp_id ,
 		   a.branchcode ,
 		   a.exp_type ,
 		   c.item_name as line_type,
 		   a.exp_referent,
 		   a.exp_currency ,
 		   b.currencyshort  as currency,
 		   a.exp_unitprice ,
 		   a.exp_remark,
 		   a.inputter 
 	FROM  kqr_land_expend as a 
 	inner join gb_tbl_currency as b on a.exp_currency =b.currencycode 
 	inner join kqr_land_items as c on a.exp_type=c.item_id 
    WHERE a.exp_id LIKE CONCAT('%', v_id, '%')  
    AND c.item_type LIKE CONCAT('%', v_type, '%')
    AND a.branchcode = v_branchcode
    AND A.postreferent IS NULL ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_register` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_currency` VARCHAR(5), IN `v_name` VARCHAR(255) CHARSET utf8, IN `v_plan` VARCHAR(50), IN `v_type` VARCHAR(50), IN `v_size` VARCHAR(50), IN `v_street` VARCHAR(50), IN `v_inactive` INT, IN `v_views` INT, IN `v_cost` DECIMAL(13,4), IN `v_up` DECIMAL(13,4), IN `v_remark` VARCHAR(250) CHARSET utf8, IN `v_inputter` VARCHAR(50))  BEGIN
    DECLARE vsubm_id varchar(50);

   IF (v_status = 'i') THEN

		CALL gb_next_id_branch(v_branchcode,'land_register', '1', vsubm_id);
		
		INSERT INTO kqr_land_register_items (rg_id, branchcode, rg_name, currency, inactive, p_view, plan_id, type_id, size_id, street_id, cost, unitprice, remark, inputter, trandate)
		  VALUES (vsubm_id, v_branchcode, v_name, v_currency, v_inactive, v_views, v_plan, v_type, v_size, v_street, v_cost, v_up, v_remark, v_inputter, NOW());
	ELSEIF (v_status = 'u') THEN

		UPDATE kqr_land_register_items AS a
		SET a.rg_name = v_name,
		    a.currency = v_currency,
		    a.inactive = v_inactive,
		    a.p_view = v_views,
		    a.plan_id = v_plan,
		    a.type_id = v_type,
		    a.size_id = v_size,
		    a.street_id = v_street,
		    a.cost = v_cost,
		    a.unitprice = v_up,
		    a.remark = v_remark
		WHERE a.rg_id = v_code
		AND a.branchcode = v_branchcode;

   END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_land_sale` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(255), IN `v_cus_id` VARCHAR(255), IN `v_item_id` VARCHAR(255), IN `v_up` DECIMAL(13,2), IN `v_discount` DECIMAL(13,2), IN `v_amount` DECIMAL(13,2), IN `v_remark` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
   DECLARE vsubm_id varchar(50);
  DECLARE v_rg_name varchar(50);
  DECLARE v_cost DECIMAL(13, 2);
  DECLARE v_sys_amount DECIMAL(13, 2);

 
  IF (v_status = 'i') THEN

        SET v_rg_name = ( SELECT DISTINCT klri.rg_name FROM kqr_land_register_items klri WHERE klri.branchcode = v_branchcode AND klri.rg_id = v_item_id);
          
        SET v_cost = ( SELECT DISTINCT klri.cost FROM kqr_land_register_items klri WHERE klri.branchcode = v_branchcode AND klri.rg_id = v_item_id);
      
        SET v_sys_amount = (v_up - ((v_up * v_discount) / 100));

		CALL gb_next_id_branch(v_branchcode,'land_sale', '1', vsubm_id);

		INSERT INTO kqr_land_sale (sal_id, rg_id, cus_id, branchcode, rg_name, cost, unitprice, discount, amount,sys_amount, inputter , trandate)
		  VALUES (vsubm_id, v_item_id, v_cus_id, v_branchcode, v_rg_name, v_cost, v_up, v_discount, v_amount,v_sys_amount, v_inputter, NOW());

	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_left_menus` ()  BEGIN
SELECT
  *
FROM tbl_sub_left_menu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_post_add_quote` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(10), IN `v_branchcode` VARCHAR(10), IN `v_type` VARCHAR(20), IN `v_quote` TEXT, IN `v_inputter` VARCHAR(255))  begin
	 	  DECLARE vsubm_id varchar(50);
	  if (v_status = 'I') then
	  	CALL gb_next_id_branch(v_branchcode,'quote_code', '1', vsubm_id);
	  	
	  	insert into post_tbl_quotes (id,branchcode,line ,quote,inputter,inputdate) values (vsubm_id,v_branchcode,v_type,v_quote,v_inputter,now());
	  
	 else 
	 	update post_tbl_quotes a set 
	 		   a.line =v_type,
	 		   a.quote= v_quote
	 	
	 	where a.branchcode=v_branchcode and a.id=v_code;
	  end if;
	 
	 select vsubm_id as trancode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_post_get_sql` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(25), IN `v_condition2` VARCHAR(25))  begin
	 IF (v_condition1='all')THEN 
		SET v_condition1='%';
	END IF ;
 	 if v_status = 'contant_fix' then
 	 	select a.con_value  as id,
 	 		   a.con_display  as name 
 	 	from gb_sys_contant_fix a 
 	 	where a.con_name=v_condition1 
 	 	order by a.con_value ;
 	 elseif v_status = 'quote_list' then
 	 	select distinct 
 	 		   a.id ,
 	 		   a.branchcode ,
 	 		   a.line,
 	 		   b.con_display  as quotetype,
 	 		   a.quote ,
 	 		   a.inputter ,
 	 		   a.inputdate 
 	 	from post_tbl_quotes a 
 	 	inner join gb_sys_contant_fix b on a.line=b.con_value and b.con_name='quote'
 	 	where a.branchcode LIKE CONCAT(v_branchcode, '%') and a.id LIKE CONCAT(v_condition1, '%')
 	 	order by a.inputdate DESC;
 	 end if ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_count_stock` (IN `v_status` VARCHAR(20), IN `v_code` VARCHAR(20), IN `v_branchcode` VARCHAR(20), IN `v_stock` VARCHAR(20), IN `v_pro_code` VARCHAR(20), IN `v_qty` VARCHAR(20), IN `v_remark` VARCHAR(20), IN `v_token` VARCHAR(200), IN `v_inputter` VARCHAR(50))  BEGIN
  	DECLARE p_sysdocnum 	varchar(50);
	DECLARE p_tran_code 	varchar(50);
	DECLARE v_pro_barcode 	varchar(50);
	DECLARE vexsisting 		varchar(50);
	
	IF (v_status='I')THEN 
		
		SET vexsisting= IFNULL((SELECT sys_token FROM pos_tbl_una_count_stock as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		IF (vexsisting='')THEN
			CALL gb_next_id_branch(v_branchcode,'pos_stocktransfer', '0', p_tran_code);
			
			INSERT INTO pos_tbl_una_count_stock(tran_code ,branchcode,stockcode,remark ,inputter ,inputdate,sys_token)
				        values (p_tran_code,v_branchcode,v_stock,v_remark,v_inputter,now(),v_token);
		END IF;
	
		CALL gb_next_id_branch(v_branchcode,'pos_stocktransfer', '0', p_sysdocnum);
	
		SET v_pro_barcode=IFNULL(( SELECT a.barcode FROM pos_tbl_products as a WHERE a.branchcode=v_branchcode and a.pro_id=v_pro_code ORDER BY a.pro_id LIMIT 1),0); 
		SET p_tran_code= IFNULL((SELECT tran_code FROM pos_tbl_una_count_stock as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		
			
		INSERT INTO pos_tbl_una_count_stock_detail(sysdocnum,branchcode,tran_code,pro_code,barcode,qty) values (p_sysdocnum,v_branchcode,p_tran_code,v_pro_code,v_pro_barcode,v_qty);
		
	
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_customer` (IN `v_status` VARCHAR(20), IN `v_branchcode` VARCHAR(20), IN `v_code` VARCHAR(20), IN `v_name` VARCHAR(50), IN `v_gender` VARCHAR(20), IN `v_phone` VARCHAR(20), IN `v_inactive` VARCHAR(20), IN `v_address` VARCHAR(200), IN `v_inputter` VARCHAR(50))  BEGIN
  	  	DECLARE p_customerid 	varchar(50);

	IF (v_status='I')THEN

		CALL gb_next_id_branch(v_branchcode,'pos_customer', '0', p_customerid);


		INSERT INTO pos_tbl_customers (cus_id,branchcode ,cus_name,cus_gender,cus_phone,inactive,cus_address,inputter ,inputdate)
								  VALUES (p_customerid,v_branchcode,v_name,v_gender,v_phone,v_inactive,v_address,v_inputter,NOW());

	ELSEIF v_status = 'U' THEN

		UPDATE  pos_tbl_customers as a
				SET a.cus_name=v_name,
					a.cus_gender=v_gender,
					a.cus_phone =v_phone,
					a.inactive =v_inactive,
					a.cus_address=v_address,
					a.inputdate=now()
		WHERE a.branchcode =v_branchcode and a.cus_id=v_code;

	ELSEIF v_status = 'auto' THEN

			INSERT INTO pos_tbl_customers (cus_id,branchcode ,cus_name,cus_gender,cus_phone,inactive,cus_address,inputter,inputdate)
								  VALUES (v_code,v_branchcode,v_name,v_gender,v_phone,v_inactive,v_address,v_inputter,NOW());

	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_expense` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(255), IN `v_branchcode` VARCHAR(25), IN `v_line_id` VARCHAR(255), IN `v_referent` VARCHAR(250), IN `v_currency` VARCHAR(250), IN `v_amount` VARCHAR(25), IN `v_remark` VARCHAR(255), IN `v_inputter` VARCHAR(50))  BEGIN
	DECLARE vsubm_id varchar(50);
	 
	IF (v_status = 'expense') THEN

		CALL gb_next_id_branch(v_branchcode,'pos_expense', '1', vsubm_id);
		
		SET v_code=vsubm_id;
		 
		INSERT INTO pos_tbl_una_expense (tran_code ,branchcode,lin_id,currency ,amount,referent,remark,inputter ,inputdate) VALUES (vsubm_id,v_branchcode,v_line_id,v_currency,v_amount,v_referent,v_remark,v_inputter,NOW());
	ELSEIF (v_status = 'income') THEN
		
		CALL gb_next_id_branch(v_branchcode,'pos_expense', '1', vsubm_id);
		
		SET v_code=vsubm_id;
		 
		INSERT INTO pos_tbl_una_income (tran_code ,branchcode,lin_id,currency ,amount,referent,remark,inputter,inputdate) 
					VALUES (vsubm_id,v_branchcode,v_line_id,v_currency,v_amount,v_referent,v_remark,v_inputter,NOW());
	END IF;

	SELECT v_code AS trancode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_file` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_file_path` VARCHAR(250), IN `v_file_name` VARCHAR(250), IN `v_org_name` VARCHAR(255), IN `v_file_ext` VARCHAR(250), IN `v_line_type` VARCHAR(20), IN `v_inputter` VARCHAR(255))  BEGIN
 	DECLARE vsubm_id varchar(50);
	 
	IF (v_status = 'I') THEN
		CALL gb_next_id_branch(v_branchcode,'pos_file', '1', vsubm_id);		
		 
		INSERT INTO pos_tbl_una_document_file(sysdonum,trancode,branchcode,file_path,file_name,org_name,file_ext,status,inputter ,inputdate) 
				VALUES (vsubm_id,v_code,v_branchcode,v_file_path,v_file_name,v_org_name,v_file_ext,v_line_type,v_inputter,NOW());

	END IF;

	SELECT vsubm_id AS trancode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_invoices` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_customerid` VARCHAR(20), IN `v_cus_name` VARCHAR(200), IN `v_cus_phone` VARCHAR(50), IN `v_cus_address` VARCHAR(50), IN `v_delivery` DECIMAL(13,4), IN `v_procode` VARCHAR(20), IN `v_stockcode` VARCHAR(20), IN `v_up` DECIMAL(13,4), IN `v_qty` DECIMAL(13,4), IN `v_discount` DECIMAL(13,4), IN `v_amount` DECIMAL(13,4), IN `v_token` VARCHAR(200), IN `v_inputter` VARCHAR(200))  BEGIN
 DECLARE v_invoice 	varchar(50);
	DECLARE v_sysdonum 	varchar(50);
	DECLARE vexsisting 	varchar(50);
	DECLARE v_cus_id 	varchar(50);


	DECLARE v_pro_cost 		DECIMAL(13,4);
	DECLARE v_pro_barcode 	varchar(50);

	
	IF (v_customerid='' or v_customerid is null )THEN
		
		CALL gb_next_id_branch(v_branchcode,'pos_customer', '0', v_cus_id);
		
		CALL proc_pos_add_customer ('auto',v_branchcode,v_cus_id,v_cus_name,'01',v_cus_phone,'0',v_cus_address,v_inputter);
	
	ELSE
		SET v_cus_id=v_customerid;
	END IF;


	IF (v_status = 'I') THEN
	
		SET vexsisting= IFNULL((SELECT sys_token FROM pos_tbl_una_invoices as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		
		IF (vexsisting='')THEN
		
			CALL gb_next_id_branch(v_branchcode,'pos_invoice', '0', v_invoice);
			
			INSERT INTO pos_tbl_una_invoices (inv_num,cus_id,branchcode,inv_date,inv_exchange,inputter ,inputdate,sys_token) 
						values (v_invoice,v_cus_id,v_branchcode,now(),'4100',v_inputter,NOW(),v_token);
					
		
			IF (v_delivery<>'' or v_delivery is not null ) AND v_delivery>0 THEN
			
				call pos_add_fee ('I','',v_branchcode,v_invoice,'01',v_delivery);
				
			
			END IF;

		END IF;
	
			SET v_invoice= IFNULL((SELECT a.inv_num FROM pos_tbl_una_invoices as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
			SET v_pro_cost=IFNULL(( SELECT a.pro_cost FROM pos_tbl_products as a WHERE a.branchcode=v_branchcode and a.pro_id=v_procode ORDER BY a.pro_id LIMIT 1),0); 
			SET v_pro_barcode=IFNULL(( SELECT a.barcode FROM pos_tbl_products as a WHERE a.branchcode=v_branchcode and a.pro_id=v_procode ORDER BY a.pro_id LIMIT 1),0); 
		
			CALL gb_next_id_branch(v_branchcode,'pos_invoice_sysdonum', '0', v_sysdonum);
		
		
			INSERT INTO pos_tbl_una_stockouts (sto_num,branchcode,inv_num,pro_code,pro_barcode,stock_code,pro_cost,pro_qty,pro_up,pro_discount,pro_amount)
						values (v_sysdonum,v_branchcode,v_invoice,v_procode,v_pro_barcode,v_stockcode,v_pro_cost,v_qty,v_up,v_discount,v_amount);
		
		
	END IF; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_line` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(255), IN `v_branchcode` VARCHAR(25), IN `v_line_type` VARCHAR(10), IN `v_line_name` VARCHAR(250), IN `v_inactive` VARCHAR(2), IN `v_remark` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
 	  	DECLARE vsubm_id varchar(50);

	IF (v_status = 'I') THEN

		CALL gb_next_id_branch(v_branchcode,'pos_line', '1', vsubm_id);

		SET v_code=vsubm_id;

		INSERT INTO pos_tbl_proline (line_id,branchcode,line_name,line_type,inactive,line_remark,inputter,inputdate) VALUES (vsubm_id,v_branchcode,v_line_name,v_line_type,v_inactive,v_remark,v_inputter,NOW());

   ELSE

		UPDATE pos_tbl_proline a
		SET a.line_name=v_line_name,
			a.inactive=v_inactive,
			a.line_remark=v_remark,
			a.inputter =v_inputter,
			a.inputdate=NOW()

		WHERE a.branchcode = v_branchcode
		AND a.line_id = v_code;


	END IF;

	SELECT v_code AS trancode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_product` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_barcode` VARCHAR(20), IN `v_type` VARCHAR(20), IN `v_line` VARCHAR(20), IN `v_name` VARCHAR(250), IN `v_cost` DECIMAL(13,4), IN `v_up` DECIMAL(13,4), IN `v_discount` DECIMAL(13,4), IN `v_inactive` VARCHAR(10), IN `v_remark` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
	DECLARE vsubm_id varchar(50);
	DECLARE vchecking varchar(50);
	DECLARE specialty CONDITION FOR SQLSTATE '45000';

 


	IF (v_status = 'I') THEN

		CALL gb_next_id_branch(v_branchcode,'pos_product', '1', vsubm_id);
		
		SET v_code=vsubm_id;
	
	INSERT INTO pos_tbl_products (pro_id,branchcode,barcode,pro_type,pro_line,pro_name,pro_cost,pro_up,pro_discount,pro_inactive,remark,inputter ,inputdate)
		        VALUES (vsubm_id,v_branchcode,v_barcode,v_type,v_line,v_name,v_cost,v_up,v_discount,v_inactive,v_remark,v_inputter,NOW());
		 

   	ELSE

		UPDATE pos_tbl_products a 
		set a.pro_inactive =v_inactive,
			a.barcode=v_barcode,
		    a.pro_name =v_name,
		    a.pro_type=v_type,
		    a.pro_line=v_line,
		    a.pro_cost=v_cost,
		    a.pro_up =v_up,
		    a.pro_discount =v_discount,
		    a.remark=v_remark
		where a.branchcode=v_branchcode and a.pro_id=v_code;
	

	END IF;

	SELECT v_code AS trancode;
 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_purchaseorder` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_supply` VARCHAR(20), IN `v_invoice` VARCHAR(200), IN `v_remark` VARCHAR(20), IN `v_procode` VARCHAR(20), IN `v_stockcode` VARCHAR(20), IN `v_cost` DECIMAL(13,4), IN `v_qty` DECIMAL(13,4), IN `v_discount` DECIMAL(13,4), IN `v_amount` DECIMAL(13,4), IN `v_pro_remark` VARCHAR(200), IN `v_token` VARCHAR(200), IN `v_inputter` VARCHAR(200))  BEGIN
	 	DECLARE vpur_id varchar(50);
	DECLARE vchecking varchar(50);
	DECLARE specialty CONDITION FOR SQLSTATE '45000';
	
	DECLARE vexsisting varchar(50);
	DECLARE vbarcode   varchar(50);
	DECLARE vsysdonum   varchar(50);

	IF (v_status = 'I') THEN
		
		SET vexsisting= IFNULL((SELECT sys_token FROM pos_tbl_una_purchase_order as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		
		IF (vexsisting='')THEN
		
			CALL gb_next_id_branch(v_branchcode,'pos_purchaseorder', '0', vpur_id);
			
			INSERT INTO pos_tbl_una_purchase_order (pur_id,branchcode,sup_id,pur_invoice,remark,inputter ,inputdate,sys_token) 
						values (vpur_id,v_branchcode,v_supply,v_invoice,v_remark,v_inputter,NOW(),v_token);

		END IF;
	
			SET vpur_id= IFNULL((SELECT pur_id FROM pos_tbl_una_purchase_order as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		
			SET vbarcode=IFNULL((SELECT a.barcode FROM pos_tbl_products as a where a.branchcode =v_branchcode and a.pro_id =v_procode ORDER BY a.barcode LIMIT 1),''); 
		
			CALL gb_next_id_branch(v_branchcode,'pos_purchase_sysdonum', '0', vsysdonum);
			
		
			INSERT INTO pos_tbl_una_purchase_details (sysdonum,branchcode,pur_id,pro_code,stockcode,barcode,pro_cost,pro_qty,pro_discount,pur_amount,currency,pur_remark) 
			values (vsysdonum,v_branchcode,vpur_id,v_procode,v_stockcode,vbarcode,v_cost,v_qty,v_discount,v_amount,'01',v_pro_remark);
		
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_stock_transfer` (IN `v_status` VARCHAR(20), IN `v_code` VARCHAR(20), IN `v_branchcode` VARCHAR(20), IN `v_f_stock` VARCHAR(50), IN `v_t_stock` VARCHAR(20), IN `v_pro_code` VARCHAR(20), IN `v_qty` VARCHAR(20), IN `v_remark` VARCHAR(250), IN `v_token` VARCHAR(200), IN `v_inputter` VARCHAR(50))  BEGIN
	 	DECLARE p_sysdocnum 	varchar(50);
	DECLARE p_tran_code 	varchar(50);
	DECLARE v_pro_barcode 	varchar(50);
	DECLARE vexsisting 		varchar(50);
	
	IF (v_status='I')THEN 
		
		SET vexsisting= IFNULL((SELECT sys_token FROM pos_tbl_una_stocktransfer as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		IF (vexsisting='')THEN
			CALL gb_next_id_branch(v_branchcode,'pos_countstock', '0', p_tran_code);
			
			INSERT INTO pos_tbl_una_stocktransfer(tran_code ,branchcode,f_stock,t_stock,remark ,inputter ,inputdate,sys_token)
				        values (p_tran_code,v_branchcode,v_f_stock,v_t_stock,v_remark,v_inputter,now(),v_token);
		END IF;
	
	
		CALL gb_next_id_branch(v_branchcode,'pos_countstock', '0', p_sysdocnum);
	
		SET v_pro_barcode=IFNULL(( SELECT a.barcode FROM pos_tbl_products as a WHERE a.branchcode=v_branchcode and a.pro_id=v_pro_code ORDER BY a.pro_id LIMIT 1),0); 
		SET p_tran_code= IFNULL((SELECT tran_code FROM pos_tbl_una_stocktransfer as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		
		INSERT INTO pos_tbl_una_stocktransfer_detail (sysdocnum,branchcode,tran_code,pro_code,barcode,qty) values (p_sysdocnum,v_branchcode,p_tran_code,v_pro_code,v_pro_barcode,v_qty);
		
	
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_add_supplier` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_type` VARCHAR(20), IN `v_name` VARCHAR(250), IN `v_inactive` VARCHAR(2), IN `v_phone` VARCHAR(255), IN `v_email` VARCHAR(255), IN `v_websit` VARCHAR(255), IN `v_address` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
	 	DECLARE vsubm_id varchar(50);
	 
	IF (v_status = 'I') THEN

		CALL gb_next_id_branch(v_branchcode,'pos_supplier', '1', vsubm_id);
		
		SET v_code=vsubm_id;
		 
		INSERT INTO pos_tbl_supplier(sup_id,branchcode,sup_type,sup_name,sup_phone,sup_email,sup_address,sup_website,inactive,inputter ,inputdate) 
			   VALUES (vsubm_id,v_branchcode,v_type,v_name,v_phone,v_email,v_address,v_websit,v_inactive,v_inputter,NOW());

   	ELSE

		UPDATE pos_tbl_supplier a 
		set a.inactive =v_inactive,
		    a.sup_name =v_name,
		    a.sup_type=v_type,
		    a.sup_phone=v_phone,
		    a.sup_email=v_email,
		    a.sup_website =v_websit,
		    a.sup_address=v_address
		where a.branchcode=v_branchcode and a.sup_id=v_code;
	

	END IF;

	SELECT v_code AS trancode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_authorize` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
	 
	IF v_status = 'auth_pos_purchase' THEN
		
		INSERT INTO pos_tbl_purchase_order (pur_id,branchcode,sup_id,pur_invoice,remark,inputter ,inputdate,sys_token) 
		SELECT pur_id,branchcode,sup_id,pur_invoice,remark,inputter ,inputdate,sys_token 
		FROM pos_tbl_una_purchase_order as a 
		where a.branchcode=v_branchcode and a.pur_id=v_id;
	
		
		INSERT INTO pos_tbl_purchase_details (sysdonum,pur_id,branchcode,pro_code,barcode,stockcode,pro_cost,pro_up,pro_qty,pro_discount,pur_amount,currency,pur_remark,pur_exchange,pro_expired)
					SELECT sysdonum,pur_id,branchcode,pro_code,barcode,stockcode ,pro_cost,pro_up,pro_qty,pro_discount,pur_amount,currency,pur_remark,pur_exchange,pro_expired
					FROM pos_tbl_una_purchase_details as a 
					where a.branchcode=v_branchcode and a.pur_id=v_id;
				
		DELETE a FROM pos_tbl_una_purchase_order as a where a.branchcode=v_branchcode and a.pur_id=v_id;
		DELETE a FROM pos_tbl_una_purchase_details as a where a.branchcode=v_branchcode and a.pur_id=v_id;
	
		-- AutoPost transaction
		CALL proc_pos_purchase_post(v_status,v_branchcode,v_id,v_inputter);
 
	ELSEIF v_status = 'auth_pos_invoice' THEN 
		
		DELETE a FROM pos_tbl_invoices as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		DELETE a FROM pos_tbl_stockouts as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
	
	
		INSERT INTO pos_tbl_invoices (inv_num,cus_id,branchcode,inv_date,inv_exchange,inputter,inputdate,sys_token,authorizer,auth_date)
			   SELECT inv_num,cus_id,branchcode,inv_date,inv_exchange,inputter,inputdate,sys_token,v_inputter,NOW() 
			   FROM pos_tbl_una_invoices as a 
			   WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
	
		INSERT INTO pos_tbl_stockouts (sto_num,branchcode,inv_num,pro_code,pro_barcode ,stock_code,pro_cost,pro_qty,pro_up,pro_discount,pro_amount)
				SELECT	sto_num,branchcode,inv_num,pro_code,pro_barcode,stock_code,pro_cost,pro_qty,pro_up,pro_discount,pro_amount
				FROM pos_tbl_una_stockouts as a 
				WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		
			
		DELETE a FROM pos_tbl_una_invoices as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		DELETE a FROM pos_tbl_una_stockouts as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
	
		-- AutoPost transaction
		
		CALL proc_pos_invoice_post(v_status,v_branchcode,v_id,v_inputter);



	ELSEIF v_status = 'auth_stock_transfer' THEN 
	
	
		   INSERT INTO pos_tbl_stocktransfer (tran_code,branchcode,f_stock,t_stock,remark,inputter ,inputdate,authorizer,auth_date,sys_token)
		   			   SELECT tran_code ,branchcode,f_stock,t_stock,remark,inputter ,inputdate,v_inputter,now(),sys_token 
		   			   FROM pos_tbl_una_stocktransfer as a where a.branchcode =v_branchcode and a.tran_code = v_id;
		   	
		   INSERT INTO pos_tbl_stocktransfer_detail (sysdocnum,branchcode,tran_code,pro_code,barcode,qty) 
		   			   SELECT sysdocnum,branchcode,tran_code,pro_code,barcode,qty 
		   			   FROM pos_tbl_una_stocktransfer_detail as a where a.branchcode =v_branchcode and a.tran_code = v_id;
		   			  
		   			  
		   DELETE a FROM pos_tbl_una_stocktransfer as a WHERE a.branchcode=v_branchcode and a.tran_code =v_id;
		   DELETE a FROM pos_tbl_una_stocktransfer_detail as a WHERE a.branchcode=v_branchcode and a.tran_code =v_id;
		  
		  	-- AutoPost transaction
		   CALL proc_pos_stock_transfer_post(v_status,v_branchcode,v_id,v_inputter);
		   
	ELSEIF v_status = 'auth_count_stock' THEN 
	
			INSERT INTO pos_tbl_count_stock (tran_code,branchcode,stockcode ,remark,inputter,inputdate,authorizer,auth_date,sys_token)
		   			   SELECT tran_code ,branchcode,stockcode,remark,inputter,inputdate,v_inputter,now(),sys_token 
		   			   FROM pos_tbl_una_count_stock as a where a.branchcode =v_branchcode and a.tran_code = v_id;
		   	
		   	INSERT INTO pos_tbl_count_stock_detail (sysdocnum,branchcode,tran_code,pro_code,barcode,qty) 
		   			   SELECT sysdocnum,branchcode,tran_code,pro_code,barcode,qty 
		   			   FROM pos_tbl_una_count_stock_detail as a where a.branchcode =v_branchcode and a.tran_code = v_id;
		   			  
		   			  
		   	DELETE a FROM pos_tbl_una_count_stock as a WHERE a.branchcode=v_branchcode and a.tran_code =v_id;
		   	DELETE a FROM pos_tbl_una_count_stock_detail as a WHERE a.branchcode=v_branchcode and a.tran_code =v_id;
		   
		  	-- AutoPost transaction
		   	CALL proc_pos_count_stock_post(v_status,v_branchcode,v_id,v_inputter);
	ELSEIF v_status = 'auth_return_stock' THEN 
		
		DELETE a FROM pos_tbl_invoice_return as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		DELETE a FROM pos_tbl_stockout_return as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		
		INSERT INTO pos_tbl_invoice_return (inv_num,cus_id,branchcode,inv_date,inv_exchange,inv_referent ,inv_reason ,inputter,inputdate,sys_token,authorizer,auth_date)
			   SELECT inv_num,cus_id,branchcode,inv_date,inv_exchange,inv_referent ,inv_reason ,inputter,inputdate,sys_token,v_inputter,NOW() 
			   FROM pos_tbl_una_invoice_return as a 
			   WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
	
		INSERT INTO pos_tbl_stockout_return (sto_num,branchcode,inv_num,pro_code,pro_barcode ,stock_code,pro_cost,pro_qty,pro_up,pro_discount,pro_amount)
				SELECT	sto_num,branchcode,inv_num,pro_code,pro_barcode,stock_code,pro_cost,pro_qty,pro_up,pro_discount,pro_amount
				FROM pos_tbl_una_stockout_return as a 
				WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		
		DELETE a FROM pos_tbl_una_invoice_return as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
		DELETE a FROM pos_tbl_una_stockout_return as a WHERE a.branchcode=v_branchcode and a.inv_num=v_id;
	
		-- AutoPost transaction
		CALL proc_pos_return_invoice_post(v_status,v_branchcode,v_id,v_inputter);


	ELSEIF v_status = 'auth_expense' THEN 
		DELETE a FROM pos_tbl_expense as a WHERE a.branchcode=v_branchcode and a.tran_code=v_id;
	
		INSERT INTO pos_tbl_expense (tran_code,branchcode,lin_id,currency,amount,referent,remark,inputter,inputdate,authorizer,auth_date)
				    select tran_code,branchcode,lin_id,currency,amount,referent,remark,inputter,inputdate,v_inputter,NOW() 
				    FROM  pos_tbl_una_expense  as a 
				    WHERE a.branchcode=v_branchcode and a.tran_code = v_id;
		
		INSERT INTO pos_tbl_document_file(sysdonum,trancode,branchcode,file_path,file_name,org_name,file_ext,status,inputter,inputdate) 
				select DISTINCT a.sysdonum,a.trancode,a.branchcode,a.file_path,a.file_name,a.org_name,a.file_ext,a.status,a.inputter,a.inputdate
				FROM pos_tbl_una_document_file as a 
				WHERE a.branchcode=v_branchcode and a.trancode =v_id;
			
		DELETE a FROM pos_tbl_una_document_file as a inner join pos_tbl_expense as b on a.branchcode=b.branchcode and a.trancode=b.tran_code WHERE b.branchcode=v_branchcode and b.tran_code=v_id;
		DELETE a FROM pos_tbl_una_expense as a WHERE a.branchcode=v_branchcode and a.tran_code=v_id;
	ELSEIF v_status = 'auth_income' THEN 
		DELETE a FROM pos_tbl_income as a WHERE a.branchcode=v_branchcode and a.tran_code=v_id;
	
	
		INSERT INTO pos_tbl_income (tran_code,branchcode,lin_id,currency,amount,referent,remark,inputter,inputdate,authorizer,auth_date)
				    select tran_code,branchcode,lin_id,currency,amount,referent,remark,inputter,inputdate,v_inputter,NOW() 
				    FROM  pos_tbl_una_income  as a 
				    WHERE a.branchcode=v_branchcode and a.tran_code = v_id;
				   
		INSERT INTO pos_tbl_document_file(sysdonum,trancode,branchcode,file_path,file_name,org_name,file_ext,status,inputter,inputdate) 
				select DISTINCT a.sysdonum,a.trancode,a.branchcode,a.file_path,a.file_name,a.org_name,a.file_ext,a.status,a.inputter,a.inputdate
				FROM pos_tbl_una_document_file as a 
				WHERE a.branchcode=v_branchcode and a.trancode =v_id;
	
		DELETE a FROM pos_tbl_una_document_file as a inner join pos_tbl_expense as b on a.branchcode=b.branchcode and a.trancode=b.tran_code WHERE b.branchcode=v_branchcode and b.tran_code=v_id;
		DELETE a FROM pos_tbl_una_income as a WHERE a.branchcode=v_branchcode and a.tran_code=v_id;
	END IF;
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_auth_tiller` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(255), IN `v_branchcode` VARCHAR(25), IN `v_token` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
	 	IF (v_status = 'I') THEN
	
		UPDATE pos_tbl_expense as a 
				set a.close_num=v_token,
					a.close_date=NOW() 
		where a.branchcode=v_branchcode and a.tran_code=v_code;
	

		UPDATE pos_tbl_income as a 
				set a.close_num=v_token,
					a.close_date=NOW() 
		where a.branchcode=v_branchcode and a.tran_code=v_code;
	
	END IF ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_checkerror` (IN `v_status` VARCHAR(25), IN `v_id` VARCHAR(255), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(50))  BEGIN
		
	DECLARE vchecking varchar(50);
	DECLARE specialty CONDITION FOR SQLSTATE '45000';

	 IF v_status = 'pos_barcode' THEN
	 	  	SET vchecking='';
	  		SET vchecking=IFNULL((SELECT a.barcode FROM pos_tbl_products as a where a.branchcode =v_branchcode and a.barcode = v_id and (a.pro_id<>IFNULL(v_condition1,''))  ORDER BY a.barcode DESC LIMIT 1),'');

			IF(vchecking<>'')THEN

				 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
				 SELECT MESSAGE_TEXT;

			END IF ;
	 ELSEIF v_status = 'pos_referent' THEN
	 	SET vchecking='';
	  	SET vchecking=IFNULL((SELECT a.inv_num FROM pos_tbl_invoices as a where a.branchcode =v_branchcode and a.inv_num = v_id ORDER BY a.inv_num DESC LIMIT 1),'');
	 	IF(vchecking='')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;

	ELSEIF v_status = 'pos_product' THEN
	 	 SET vchecking='';
	  	 SET vchecking=IFNULL((SELECT a.barcode FROM pos_tbl_products as a inner join pos_tbl_stockouts as b on a.branchcode=b.branchcode and a.pro_id=b.pro_id  where a.branchcode =v_branchcode and a.pro_id = v_id   ORDER BY a.barcode DESC LIMIT 1),'');
		IF(vchecking<>'')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;
	ELSEIF v_status = 'pos_line' then
	
	 	SET vchecking='';
	  	SET vchecking=IFNULL((select  a.pro_line from  pos_tbl_products a inner join pos_tbl_proline b on a.branchcode=b.branchcode  and a.pro_line=b.line_id where a.branchcode =v_branchcode  and a.pro_line = v_id    ORDER BY a.barcode DESC LIMIT 1),'');
		 
		IF(vchecking<>'')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;
	
		SET vchecking='';
	  	SET vchecking=IFNULL((select  a.pro_line from  pos_tbl_products a inner join pos_tbl_proline b on a.branchcode=b.branchcode  and a.pro_type=b.line_id where a.branchcode =v_branchcode  and a.pro_type = v_id    ORDER BY a.barcode DESC LIMIT 1),'');
		 
		IF(vchecking<>'')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;
	
	
		SET vchecking='';
	  	SET vchecking=IFNULL((select  a.stockcode from  pos_tbl_transactions a inner join pos_tbl_proline b on a.branchcode=b.branchcode  and a.stockcode =b.line_id where a.branchcode =v_branchcode  and a.stockcode = v_id    ORDER BY a.stockcode DESC LIMIT 1),'');
		 
		IF(vchecking<>'')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;
	
	
		SET vchecking='';
	  	SET vchecking=IFNULL((select  a.lin_id from  pos_tbl_income  a inner join pos_tbl_proline b on a.branchcode=b.branchcode  and a.lin_id =b.line_id where a.branchcode =v_branchcode  and a.lin_id = v_id    ORDER BY a.lin_id DESC LIMIT 1),'');
		 
		IF(vchecking<>'')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;
	
		SET vchecking='';
	  	SET vchecking=IFNULL((select  a.lin_id from  pos_tbl_expense  a inner join pos_tbl_proline b on a.branchcode=b.branchcode  and a.lin_id =b.line_id where a.branchcode =v_branchcode  and a.lin_id = v_id    ORDER BY a.lin_id DESC LIMIT 1),'');
		 
		IF(vchecking<>'')THEN

			 SIGNAL SQLSTATE '42927' SET MESSAGE_TEXT = 'Error Generated';
			 SELECT MESSAGE_TEXT;

		END IF ;
	
	END IF ;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_count_stock_post` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN

	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE stockcode  	 VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_total_qty  DECIMAL(13,4);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT DISTINCT  b.pro_code, b.barcode , a.stockcode ,b.qty 
	 							  FROM pos_tbl_count_stock as a 
	 							  INNER JOIN pos_tbl_count_stock_detail as b on a.branchcode =b.branchcode and a.tran_code=b.tran_code
	 							  where a.branchcode =v_branchcode and a.tran_code =v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	  	SET c_total_qty=IFNULL(( SELECT sum(a.trn_qty) FROM pos_tbl_transactions as a where a.branchcode=v_branchcode and a.stockcode =stockcode and pro_code=c_pro_code),0);
	  	   
	    CALL proc_pos_post_transaction ('cut_count_stock',v_branchcode,v_id,c_pro_code, c_barcode ,stockcode,c_total_qty,v_inputter);
	    CALL proc_pos_post_transaction ('count_stock',v_branchcode,v_id,c_pro_code, c_barcode ,stockcode,c_qty,v_inputter);
	   
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,stockcode,c_date);

	   
	  END LOOP;
	  CLOSE cursor_i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_get_sql` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(25), IN `v_condition2` VARCHAR(25))  BEGIN
	 IF (v_condition1='all')THEN
 		SET v_condition1='%';
 	END IF ;

	 IF v_status = 'pos_line' THEN

	 	SELECT a.line_id ,
	 		   a.line_name,
	 		   a.inactive,
	 		   case when  a.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
	 		   a.line_remark,
	 		   a.inputter ,
	 		   a.line_type ,
	 		   b.line_name  as line
	 	FROM pos_tbl_proline as a
	 	inner join pos_tbl_line as b on a.line_type=b.line_id
	 	WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND
	 		  (a.line_id LIKE CONCAT(v_condition1, '%') or a.line_name LIKE CONCAT('%',v_condition1,'%'))
	 		  order by a.line_type,a.line_id ;
	 ELSEIF v_status = 'line' THEN

	 		SELECT a.line_id  as id,
	 		       a.line_name as name
	 		FROM pos_tbl_line as a
	 		where a.inactive='0';
	 ELSEIF v_status = 'list_supplier' THEN

	 		SELECT a.sup_id,
	 			   a.branchcode ,
	 			   a.inactive ,
	 			   a.sup_type,
	 			   b.line_name,
	 			   case when  a.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
	 			   a.sup_name ,
	 			   a.sup_phone ,
	 			   a.sup_email,
	 			   a.sup_website,
	 			   a.sub_fax ,
	 			   a.sup_address,
	 			   a.inputter ,
	 			   a.inputdate
	 		FROM pos_tbl_supplier as a
	 		inner join pos_tbl_proline as b on a.branchcode =b.branchcode  and a.sup_type=b.line_id
	 		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND
	 			  (a.sup_id LIKE CONCAT(v_condition1, '%') OR a.sup_name LIKE CONCAT('%',v_condition1,'%') OR  a.sup_phone LIKE CONCAT('%',v_condition1,'%'))
	 			 ORDER BY a.sup_type ,a.sup_id ;
	  ELSEIF v_status = 'list_product' THEN

			SELECT a.pro_id,
				   a.barcode ,
				   a.branchcode,
				   a.pro_name,
				   a.pro_type as code_type,
				   a.pro_line as  code_line,
				   b.line_name as pro_type ,
				   c.line_name  as pro_line,
				   a.pro_cost ,
				   a.pro_up ,
				   a.pro_discount ,
				   a.pro_inactive ,
				   case when  a.pro_inactive ='1' THEN 'YES' ELSE 'NO' END as status,
				   a.remark
			FROM pos_tbl_products as a
			inner join pos_tbl_proline as b on a.branchcode =b.branchcode  and a.pro_type=b.line_id
			inner join pos_tbl_proline as c on a.branchcode =c.branchcode  and a.pro_line=c.line_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND
			(a.pro_id LIKE CONCAT(v_condition1, '%') OR a.pro_name LIKE CONCAT('%',v_condition1,'%') );
	 ELSEIF v_status = 'limit_product' THEN
	 		SELECT a.pro_id,
				   a.barcode ,
				   a.branchcode,
				   a.pro_name
			FROM pos_tbl_products as a
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND
				 (a.pro_id LIKE CONCAT(v_condition1, '%') OR a.pro_name LIKE CONCAT('%',v_condition1,'%')) and   
				 a.pro_inactive='0' ORDER BY a.pro_id LIMIT 20;

	 ELSEIF v_status = 'search_product' THEN
	 	SELECT a.pro_id,
				   a.barcode ,
				   a.branchcode,
				   a.pro_name
			FROM pos_tbl_products as a
			inner join pos_tbl_proline as b on a.branchcode =b.branchcode  and a.pro_type=b.line_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND
			(a.pro_id LIKE CONCAT(v_condition1, '%') OR a.pro_name LIKE CONCAT('%',v_condition1,'%') OR a.barcode LIKE CONCAT('%',v_condition1,'%') );

	 ELSEIF v_status = 'list_purchase_order' THEN
	 		SELECT a.pur_id ,
	 			   a.sup_id ,
	 			   b.sup_name,
	 			   a.pur_invoice ,
	 			   a.remark,
	 			   a.inputter ,
	 			   a.inputdate
	 		FROM pos_tbl_una_purchase_order as a
	 		inner join pos_tbl_supplier as b on a.branchcode =b.branchcode and a.sup_id=b.sup_id
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.pur_id  LIKE  CONCAT('%',v_condition1,'%') OR a.pur_invoice LIKE  CONCAT('%',v_condition1,'%')) order by a.pur_id ,a.inputdate ;
	 ELSEIF v_status = 'list_purchase_detail' THEN

	 		SELECT a.pur_id ,
	 			   b.sup_name,
	 			   a.pur_invoice ,
	 			   c.pro_cost,
	 			   c.pro_code ,
	 			   c.barcode ,
	 			   c.pur_amount,
	 			   c.pro_discount,
	 			   d.pro_name,
	 			   c.pro_qty,
	 			   c.pur_remark,
	 			   s.line_name
	 		FROM pos_tbl_una_purchase_order as a
	 		inner join pos_tbl_supplier as b on a.branchcode =b.branchcode and a.sup_id=b.sup_id
	 		left join pos_tbl_una_purchase_details as c on a.branchcode=c.branchcode and a.pur_id=c.pur_id
	 		left join pos_tbl_products as d on d.branchcode =c.branchcode and  d.pro_id=c.pro_code
	 		left join pos_tbl_proline as s on c.branchcode=s.branchcode  and c.stockcode=s.line_id
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.pur_id  LIKE  CONCAT('%',v_condition1,'%')) order by a.pur_id ,a.inputdate ;
	 ELSEIF v_status = 'list_customer' THEN

	 		SELECT a.cus_id ,
	 			   a.cus_gender ,
	 			   a.cus_name ,
	 			    f.con_display  as gender,
	 			   a.cus_phone ,
	 			   a.inactive,
	 			   case when  a.inactive ='1' THEN 'YES' ELSE 'NO' END as status,
	 			   a.cus_address
	 		FROM pos_tbl_customers as a
	 		Left JOIN gb_sys_contant_fix f on a.cus_gender=f.con_value and f.con_name ='gender'
	 		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') and (a.cus_id  LIKE  CONCAT('%',v_condition1,'%') OR a.cus_name LIKE  CONCAT('%',v_condition1,'%') OR a.cus_phone LIKE  CONCAT('%',v_condition1,'%')) order by a.cus_id ,a.inputdate ;
	 ELSEIF v_status = 'limit_customer' THEN
	 		SELECT distinct
	 			   a.cus_id ,
	 			   f.con_display  as cus_gender,
	 			   a.cus_name,
	 			   a.inputdate
	 		FROM pos_tbl_customers as a
	 		Left JOIN gb_sys_contant_fix f on a.cus_gender=f.con_value and f.con_name ='gender'
	 		WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') and
	 			  (a.cus_id  LIKE  CONCAT('%',v_condition1,'%') OR a.cus_name LIKE  CONCAT('%',v_condition1,'%') OR a.cus_phone LIKE  CONCAT('%',v_condition1,'%'))
	 			 order by a.cus_id ,a.inputdate limit 20;
	 ELSEIF v_status = 'list_una_invoice' THEN

	 		SELECT a.inv_num ,
	 			   a.branchcode ,
	 			   a.cus_id,
	 			   b.cus_name ,
	 			   b.cus_phone,
	 			   DATE(a.inputdate) as trandate,
	 			   a.inputter
	 		FROM pos_tbl_una_invoices as a
	 		INNER JOIN pos_tbl_customers as b on a.branchcode =b.branchcode and a.cus_id =b.cus_id
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.inv_num  LIKE  CONCAT('%',v_condition1,'%')) order by a.inv_num ,a.inputdate ;

	 ELSEIF v_status = 'product_instock' THEN

	 		SELECT a.pro_code,
	 			   a.pro_barcode,
	 			   a.stockcode ,
	 			   b.line_name as stockname,
	 			   p.pro_name,

	 			   sum(CAST(a.trn_qty AS DECIMAL(10,0))) as qty
	 		FROM pos_tbl_transactions as a
	 		INNER JOIN pos_tbl_proline as b on a.branchcode=b.branchcode and a.stockcode= b.line_id
			INNER JOIN pos_tbl_products as p on a.branchcode=p.branchcode and a.pro_code =p.pro_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND (a.pro_code LIKE CONCAT(v_condition1, '%') OR a.stockcode LIKE CONCAT('%',v_condition2,'%'))
	 		GROUP BY  a.pro_code,
	 			   a.pro_barcode,
	 			   a.stockcode ,
	 			   b.line_name,
	 			   p.pro_name
	 			   HAVING qty>0
	 			   ORDER BY a.stockcode ;
	ELSEIF v_status = 'search_instock' THEN

	 		SELECT a.pro_code,
	 			   a.pro_barcode,
	 			   a.stockcode ,
	 			   b.line_name as stockname,
	 			   p.pro_name,
	 			   sum(CAST(a.trn_qty AS DECIMAL(10,0))) as qty
	 		FROM pos_tbl_transactions as a
	 		INNER JOIN pos_tbl_proline as b on a.branchcode=b.branchcode and a.stockcode= b.line_id
			INNER JOIN pos_tbl_products as p on a.branchcode=p.branchcode and a.pro_code =p.pro_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND (a.pro_code LIKE CONCAT(v_condition1, '%') AND a.stockcode LIKE CONCAT('%',v_condition2,'%'))
	 		GROUP BY  a.pro_code,
	 			   a.pro_barcode,
	 			   a.stockcode ,
	 			   b.line_name,
	 			   p.pro_name
	 			   HAVING qty<>0
	 			   ORDER BY a.stockcode,qty ;


	ELSEIF v_status = 'product_have_instock' THEN
			DROP TABLE IF EXISTS tmp_sum_invoice;
			CREATE TEMPORARY TABLE tmp_sum_invoice
		 	SELECT a.pro_code as id,
	 			   p.pro_name as name ,
	 			   sum(CAST(a.trn_qty AS DECIMAL(10,0))) as qty
	 		FROM pos_tbl_transactions as a
			INNER JOIN pos_tbl_products as p on a.branchcode=p.branchcode and a.pro_code =p.pro_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND (a.pro_code LIKE CONCAT(v_condition1, '%') OR a.stockcode LIKE CONCAT('%',v_condition2,'%'))
	 		GROUP BY  a.pro_code,
	 			   	  p.pro_name
	 		HAVING qty<>0
	 		ORDER BY qty,a.pro_code;

	 		SELECT CONVERT('' , CHAR CHARACTER SET utf8)  as id ,CONVERT('' , CHAR CHARACTER SET utf8)  as name  FROM dual
	  		union
	 		SELECT a.id,
	 			   a.name
	 		FROM tmp_sum_invoice as a ;
	 ELSEIF v_status = 'his_instock' THEN
	 		SELECT a.pro_code,
	 			   a.sysdocnum ,
				   a.pro_barcode,
	 			   b.line_name as stockname,
	 			   p.pro_name,
	 			   CAST(a.trn_qty AS DECIMAL(10,0)) as qty,
	 			   a.trn_ref ,
	 			   a.trn_status,
	 			   a.inputter ,
	 			   DATE_FORMAT(a.inputdate ,'%d/%m/%Y %r') as inputdate
	 		FROM pos_tbl_transactions as a
	 		INNER JOIN pos_tbl_proline as b on a.branchcode=b.branchcode and a.stockcode= b.line_id
			INNER JOIN pos_tbl_products as p on a.branchcode=p.branchcode and a.pro_code =p.pro_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND a.pro_code LIKE CONCAT(v_condition1, '%')
	 			   ORDER BY a.sysdocnum,a.inputdate DESC ;
	 ELSEIF v_status = 'list_una_stock_transfer' THEN

	 		SELECT a.tran_code,
	 			   a.branchcode ,
	 			   b.line_name as f_stock,
	 			   c.line_name as t_stock ,
	 			   a.remark ,
	 			   a.inputter
	 		FROM pos_tbl_una_stocktransfer as a
	 		inner join pos_tbl_proline as b on a.branchcode =b.branchcode and a.f_stock=b.line_id
	 		inner join pos_tbl_proline as c on a.branchcode =c.branchcode and a.t_stock =c.line_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND a.tran_code LIKE CONCAT('%',v_condition1,'%');
	 ELSEIF v_status = 'detail_stock_transfer' THEN
	 	SELECT a.tran_code,
	 			   a.branchcode,
	 			   b.pro_code,
	 			   CAST(b.qty AS DECIMAL(10,0)) as qty,
	 			   c.pro_name
	 		FROM pos_tbl_una_stocktransfer as a
	 		inner join pos_tbl_una_stocktransfer_detail as b on a.branchcode =b.branchcode and a.tran_code=b.tran_code
	 		INNER JOIN pos_tbl_products as c on b.branchcode=c.branchcode and b.barcode=c.barcode
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND a.tran_code LIKE CONCAT('%',v_condition1,'%');

	  ELSEIF v_status = 'list_una_countstock_list' THEN

	 		SELECT a.tran_code,
	 			   a.branchcode ,
	 			   b.line_name as stockname,
	 			   a.remark ,
	 			   a.inputter
	 		FROM pos_tbl_una_count_stock as a
	 		inner join pos_tbl_proline as b on a.branchcode =b.branchcode and a.stockcode=b.line_id
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND a.tran_code LIKE CONCAT('%',v_condition1,'%');
	 ELSEIF v_status = 'detail_countstock_list' THEN
	 	SELECT a.tran_code,
	 			   a.branchcode,
	 			   b.pro_code,
	 			   CAST(b.qty AS DECIMAL(10,0)) as qty,
	 			   c.pro_name
	 		FROM pos_tbl_una_count_stock as a
	 		inner join pos_tbl_una_count_stock_detail as b on a.branchcode =b.branchcode and a.tran_code=b.tran_code
	 		INNER JOIN pos_tbl_products as c on b.branchcode=c.branchcode and b.barcode=c.barcode
			WHERE a.branchcode LIKE CONCAT(v_branchcode, '%') AND a.tran_code LIKE CONCAT('%',v_condition1,'%');
	 ELSEIF v_status = 'list_return_pos' THEN

	 		SELECT a.inv_num ,
	 			   a.branchcode ,
	 			   a.cus_id,
	 			   b.cus_name ,
	 			   b.cus_phone,
	 			   DATE(a.inputdate) as trandate,
	 			   a.inputter
	 		FROM pos_tbl_una_invoice_return as a
	 		INNER JOIN pos_tbl_customers as b on a.branchcode =b.branchcode and a.cus_id =b.cus_id
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.inv_num  LIKE  CONCAT('%',v_condition1,'%')) order by a.inv_num ,a.inputdate ;

	 ELSEIF v_status = 'list_expense' THEN
	 		SELECT a.tran_code,
	 			   c.line_name as line,
	 			   b.currencyshort as currency,
	 			   a.amount ,
	 			   a.inputter,
	 			   a.referent ,
	 			   a.remark ,
	 			   a.inputdate
	 		FROM pos_tbl_una_expense as a
	 		INNER JOIN gb_tbl_currency as b on a.currency=b.currencycode
	 		INNER JOIN pos_tbl_proline as c on  a.branchcode =c.branchcode and a.lin_id =c.line_id
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.tran_code  LIKE  CONCAT('%',v_condition1,'%')) order by a.tran_code ,a.inputdate ;
	 ELSEIF v_status = 'list_una_exp_file' THEN
	 		SELECT a.tran_code,
	 			   b.sysdonum,
	 			   b.file_path,
	 			   b.file_name,
	 			   b.org_name,
	 			   b.file_ext,
	 			   b.status,
	 			   CONCAT(b.file_path,'/',b.file_name) as link_file
	 		FROM pos_tbl_una_expense as a
	 		inner join pos_tbl_una_document_file as b on a.branchcode =b.branchcode and a.tran_code =b.trancode
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.tran_code  LIKE  CONCAT('%',v_condition1,'%')) order by a.tran_code ,b.sysdonum ;
	 ELSEIF v_status = 'list_exp_file' THEN
	 		SELECT a.tran_code,
	 			   b.sysdonum,
	 			   b.file_path,
	 			   b.file_name,
	 			   b.org_name,
	 			   b.file_ext,
	 			   b.status,
	 			   CONCAT(b.file_path,'/',b.file_name) as link_file
	 		FROM pos_tbl_expense as a
	 		inner join pos_tbl_document_file as b on a.branchcode =b.branchcode and a.tran_code =b.trancode
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.tran_code  LIKE  CONCAT('%',v_condition1,'%')) order by a.tran_code ,b.sysdonum ;
	 ELSEIF v_status = 'list_income' THEN
	 		SELECT a.tran_code,
	 			   c.line_name as line,
	 			   b.currencyshort as currency,
	 			   a.amount ,
	 			   a.inputter,
	 			   a.referent ,
	 			   a.remark ,
	 			   a.inputdate
	 		FROM pos_tbl_una_income as a
	 		INNER JOIN gb_tbl_currency as b on a.currency=b.currencycode
	 		INNER JOIN pos_tbl_proline as c on  a.branchcode =c.branchcode and a.lin_id =c.line_id
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.tran_code  LIKE  CONCAT('%',v_condition1,'%')) order by a.tran_code ,a.inputdate ;

	ELSEIF v_status = 'list_una_income_file' THEN
	 		SELECT a.tran_code,
	 			   b.sysdonum,
	 			   b.file_path,
	 			   b.file_name,
	 			   b.org_name,
	 			   b.file_ext,
	 			   b.status,
	 			   CONCAT(b.file_path,'/',b.file_name) as link_file
	 		FROM pos_tbl_una_income as a
	 		inner join pos_tbl_una_document_file as b on a.branchcode =b.branchcode and a.tran_code =b.trancode
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.tran_code  LIKE  CONCAT('%',v_condition1,'%')) order by a.tran_code ,b.sysdonum ;
	 ELSEIF v_status = 'list_income_file' THEN
	 		SELECT a.tran_code,
	 			   b.sysdonum,
	 			   b.file_path,
	 			   b.file_name,
	 			   b.org_name,
	 			   b.file_ext,
	 			   b.status,
	 			   CONCAT(b.file_path,'/',b.file_name) as link_file
	 		FROM pos_tbl_income as a
	 		inner join pos_tbl_document_file as b on a.branchcode =b.branchcode and a.tran_code =b.trancode
	 		where a.branchcode  LIKE CONCAT(v_branchcode, '%') and (a.tran_code  LIKE  CONCAT('%',v_condition1,'%')) order by a.tran_code ,b.sysdonum ;
	 ELSEIF v_status = 'list_tiller' THEN

	 		DROP TABLE IF EXISTS tmp_list_tiller;
			CREATE TEMPORARY TABLE tmp_list_tiller
		 	SELECT a.tran_code,
	 			   c.line_name as line,
	 			   b.currencyshort as currency,
	 			   a.amount ,
	 			   a.inputter,
	 			   a.referent ,
	 			   IFNULL(a.remark,'') AS remark ,
	 			   a.inputdate ,
	 			   CONVERT('income' , CHAR CHARACTER SET utf8) as status,
	 			   CONVERT('1' , CHAR CHARACTER SET utf8) as list_order
	 		FROM pos_tbl_income as a
	 		INNER JOIN gb_tbl_currency as b on a.currency=b.currencycode
	 		INNER JOIN pos_tbl_proline as c on  a.branchcode =c.branchcode and a.lin_id =c.line_id
	 		where a.branchcode=v_branchcode  AND a.close_num is null
	 		union
	 		SELECT a.tran_code,
	 			   c.line_name as line,
	 			   b.currencyshort as currency,
	 			   a.amount ,
	 			   a.inputter ,
	 			   a.referent ,
	 			    IFNULL(a.remark,'') AS remark ,
	 			   a.inputdate ,
	 			   CONVERT('expense' , CHAR CHARACTER SET utf8) as status,
	 			   CONVERT('2' , CHAR CHARACTER SET utf8) as list_order
	 		FROM pos_tbl_expense as a
	 		INNER JOIN gb_tbl_currency as b on a.currency=b.currencycode
	 		INNER JOIN pos_tbl_proline as c on  a.branchcode =c.branchcode and a.lin_id =c.line_id
	 		where a.branchcode=v_branchcode AND a.close_num is null  ;

	 		SELECT * from tmp_list_tiller as a order by a.list_order,a.tran_code;

	END IF ;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_invoice_post` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
 	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT DISTINCT  a.pro_code , a.pro_barcode , a.stock_code ,a.pro_qty  FROM pos_tbl_stockouts as a where a.branchcode =v_branchcode and a.inv_num =v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,c_stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	    CALL proc_pos_post_transaction (v_status,v_branchcode,v_id,c_pro_code, c_barcode ,c_stockcode,c_qty,v_inputter);
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,c_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_land_tiller` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_checked` VARCHAR(25), IN `v_referent` VARCHAR(50), IN `v_inputter` VARCHAR(55))  BEGIN
	
 	 IF v_status = 'tiller' and v_checked='1' THEN

	 	UPDATE kqr_land_expend SET postreferent=v_referent,postdate=NOW()   where branchcode =v_branchcode and exp_id =v_code;
	 
	ELSEIF v_status = 'Auth_tiller' THEN
	 	
	 	INSERT INTO tbl_land_tillers (tiller_num,branchcode,inputter ,inputdate) values (v_referent,v_branchcode,v_inputter,NOW());
	 
	 END IF ;
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_post_transaction` (IN `v_status` VARCHAR(20), IN `v_branchcode` VARCHAR(20), IN `v_referent` VARCHAR(20), IN `v_procode` VARCHAR(20), IN `v_barcode` VARCHAR(20), IN `v_stockcode` VARCHAR(20), IN `v_qty` DECIMAL(13,4), IN `v_inputter` VARCHAR(50))  BEGIN

	DECLARE p_sysdocnum 	varchar(50);
	DECLARE p_trancode 		varchar(50);
	DECLARE p_qty 			varchar(50);

	
	IF (v_status = 'purchaseorder') THEN
			
		SET p_trancode='01';
	    SET p_qty=v_qty;
	ELSEIF (v_status = 'auth_pos_invoice') THEN
		SET p_trancode='02';
	    SET p_qty=(v_qty*(-1));
	ELSEIF (v_status = 'f_stocktransfer') THEN
		SET p_trancode='04';
	    SET p_qty=(v_qty*(-1));
	ELSEIF (v_status = 't_stocktransfer') THEN
		SET p_trancode='03';
	    SET p_qty=v_qty;
	ELSEIF (v_status = 'cut_count_stock') THEN
		SET p_trancode='06';
	    SET p_qty=(v_qty*(-1));
	ELSEIF (v_status = 'count_stock') THEN
		SET p_trancode='07';
	    SET p_qty=v_qty;
	ELSEIF (v_status = 'return_invoice') THEN
		SET p_trancode='09';
	    SET p_qty=v_qty;
	END IF;

	CALL gb_next_id_branch(v_branchcode,'pos_transaction', '0', p_sysdocnum);

	INSERT INTO pos_tbl_transactions (sysdocnum,branchcode,pro_code,pro_barcode,trancode,stockcode,trn_status,trn_ref,trn_qty,trn_qty_tt,inputter ,inputdate)
				values (p_sysdocnum,v_branchcode,v_procode,v_barcode,p_trancode,v_stockcode,v_status,v_referent,p_qty,0,v_inputter,NOW());
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_print` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_condition1` VARCHAR(25), IN `v_condition2` VARCHAR(25))  BEGIN
	 DECLARE v_customerid varchar(20);
	
	IF (v_status='company')THEN 
		
		SELECT a.branchcode,
			   a.branchname ,
			   a.setname,
			   a.branchshort,
			   IFNULL(a.email,'') as email,
			   IFNULL(a.phone,'') as phone,
			   IFNULL(a.website,'') as website,
			   a.address 
		FROM gb_sys_branch as a 
		WHERE a.branchcode=v_branchcode ORDER BY a.branchcode LIMIT 1;
	ELSEIF (v_status='una_customerinfo')THEN  
			
		SELECT a.cus_id ,
			   a.cus_name ,
			   IFNULL(a.cus_phone,'') as cus_phone,
			   IFNULL(a.cus_email,'') as cus_email,
			   IFNULL(a.cus_address,'') as cus_address,
			   b.inv_date ,
			   b.inv_num,
			   DATE_FORMAT(b.inputdate ,'%l:%i %p %b %e, %Y') as inv_date,
			   DATE_FORMAT(NOW() ,'%l:%i %p %b %e, %Y') as todaynow,
			   b.inputter 
		FROM pos_tbl_customers as a 
		INNER JOIN pos_tbl_una_invoices as b on a.branchcode=b.branchcode  and a.cus_id=b.cus_id 
		where a.branchcode=v_branchcode and b.inv_num=v_condition1
		ORDER BY b.inv_num LIMIT 1;
	ELSEIF (v_status='auth_customerinfo')THEN  
			
		SELECT a.cus_id ,
			   a.cus_name ,
			   IFNULL(a.cus_phone,'') as cus_phone,
			   IFNULL(a.cus_email,'') as cus_email,
			   IFNULL(a.cus_address,'') as cus_address,
			   b.inv_date ,
			   b.inv_num,
			   DATE_FORMAT(b.inputdate ,'%l:%i %p %b %e, %Y') as inv_date,
			   DATE_FORMAT(NOW() ,'%l:%i %p %b %e, %Y') as todaynow,
			   b.inputter 
		FROM pos_tbl_customers as a 
		INNER JOIN pos_tbl_invoices as b on a.branchcode=b.branchcode  and a.cus_id=b.cus_id 
		where a.branchcode=v_branchcode and b.inv_num=v_condition1
		ORDER BY b.inv_num LIMIT 1;
	
	ELSEIF (v_status='payment_method')THEN  
	
		SELECT a.pay_id,
			   CONCAT(IFNULL(a.pay_name,'') ,' : ' ,IFNULL(a.pay_account,'')) as payment_method
		FROM pos_tbl_payment_method as a 
		WHERE a.branchcode=v_branchcode ORDER BY pay_name ;
	
	ELSEIF (v_status='una_invoice')THEN 
	
		SELECT a.inv_num,
			   a.inv_date ,
			   a.inputter,
			   b.sto_num ,
			   b.pro_code ,
			   b.pro_barcode,
			   b.pro_qty ,
			   b.pro_up ,
			   b.pro_discount ,
			   b.pro_amount,
			   b.pro_cost,
			   c.pro_name,
			   s.line_name as stockname,
			   pos_get_fee_amount (a.branchcode,a.inv_num,'01') as delivery
		FROM pos_tbl_una_invoices as a 
		inner join pos_tbl_una_stockouts as b on a.branchcode =b.branchcode and a.inv_num=b.inv_num 
		inner join pos_tbl_proline as s on b.branchcode=s.branchcode and b.stock_code=s.line_id  
		left join pos_tbl_products as c on b.branchcode =c.branchcode and b.pro_code =c.pro_id 
		where a.branchcode=v_branchcode and a.inv_num=v_condition1 ORDER BY a.inv_num;
	
	

  ELSEIF (v_status='auth_invoice')THEN 
		SELECT a.inv_num,
			   a.inv_date ,
			   a.inputter,
			   b.sto_num ,
			   b.pro_code ,
			   b.pro_barcode,
			   b.pro_qty ,
			   b.pro_up ,
			   b.pro_discount ,
			   b.pro_amount,
			   b.pro_cost,
			   c.pro_name,
			   s.line_name as stockname,
			   pos_get_fee_amount (a.branchcode,a.inv_num,'01') as delivery
		FROM pos_tbl_invoices as a 
		inner join pos_tbl_stockouts as b on a.branchcode =b.branchcode and a.inv_num=b.inv_num 
		inner join pos_tbl_proline as s on b.branchcode=s.branchcode and b.stock_code=s.line_id  
		left join pos_tbl_products as c on b.branchcode =c.branchcode and b.pro_code =c.pro_id 
		where a.branchcode=v_branchcode and a.inv_num=v_condition1 ORDER BY a.inv_num;

	ELSEIF (v_status='auth_invoice')THEN 
		SELECT a.inv_num,
			   a.inv_date ,
			   a.inputter,
			   b.sto_num ,
			   b.pro_code ,
			   b.pro_barcode,
			   b.pro_qty ,
			   b.pro_up ,
			   b.pro_discount ,
			   b.pro_amount,
			   b.pro_cost,
			   c.pro_name,
			   s.line_name as stockname
		FROM pos_tbl_una_invoices as a 
		inner join pos_tbl_una_stockouts as b on a.branchcode =b.branchcode and a.inv_num=b.inv_num 
		inner join pos_tbl_proline as s on b.branchcode=s.branchcode and b.stock_code=s.line_id  
		left join pos_tbl_products as c on b.branchcode =c.branchcode and b.pro_code =c.pro_id 
		where a.branchcode=v_branchcode and a.inv_num=v_condition1 ORDER BY a.inv_num;
		
	ELSEIF (v_status='una_return_pos')THEN 
		SELECT a.inv_num,
			   a.inv_referent,
			   a.inv_reason,
			   a.inv_date ,
			   a.inputter,
			   b.sto_num ,
			   b.pro_code ,
			   b.pro_barcode,
			   b.pro_qty ,
			   b.pro_up ,
			   b.pro_discount ,
			   b.pro_amount,
			   b.pro_cost,
			   c.pro_name,
			   s.line_name as stockname
		FROM pos_tbl_una_invoice_return as a 
		inner join pos_tbl_una_stockout_return as b on a.branchcode =b.branchcode and a.inv_num=b.inv_num 
		inner join pos_tbl_proline as s on b.branchcode=s.branchcode and b.stock_code=s.line_id  
		left join pos_tbl_products as c on b.branchcode =c.branchcode and b.pro_code =c.pro_id 
		where a.branchcode=v_branchcode and a.inv_num=v_condition1 ORDER BY a.inv_num;
			
	END IF ;	
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_purchase` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
	 	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT  a.pro_code , a.barcode , a.stockcode ,a.pro_qty  FROM pos_tbl_purchase_details as a where a.branchcode =v_branchcode and a.pur_id=v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,c_stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	    CALL proc_pos_post_transaction ('purchaseorder',v_branchcode,v_id,c_pro_code, c_barcode ,c_stockcode,c_qty,v_inputter);
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,c_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_purchase_post` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
	 
	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT  a.pro_code , a.barcode , a.stockcode ,a.pro_qty  FROM pos_tbl_purchase_details as a where a.branchcode =v_branchcode and a.pur_id=v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,c_stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	    CALL proc_pos_post_transaction ('purchaseorder',v_branchcode,v_id,c_pro_code, c_barcode ,c_stockcode,c_qty,v_inputter);
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,c_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_referesh` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_procode` VARCHAR(20))  BEGIN
	

	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_date 		 DATE;
   

	
  	  DECLARE done INT DEFAULT FALSE;

	  DECLARE cursor_i CURSOR FOR SELECT DISTINCT a.pro_code ,a.stockcode FROM  pos_tbl_transactions as a where a.branchcode =v_branchcode and a.pro_code=v_procode;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code,c_stockcode;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	   
	  	
	    IF v_status = 'all' THEN
	   	 	SET c_date=(SELECT  A.inputdate FROM  pos_tbl_transactions as a where a.branchcode =v_branchcode and a.pro_code=v_procode ORDER BY a.inputdate DESC limit 1);
	   	ELSE
	   		SET c_date=DATE(NOW());
	   	 
	   	 END IF ;
   	
	    call proc_pos_referesh_by_stock (v_status,v_branchcode,c_pro_code,c_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;
	 
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_referesh_by_stock` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_procode` VARCHAR(20), IN `v_stock` VARCHAR(20), IN `v_date` DATE)  BEGIN
	
	DECLARE existing     VARCHAR(50);
	DECLARE cursor_ID    VARCHAR(50);
	DECLARE c_sysdocnum  VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_qty 		 DECIMAL(13,4);
    DECLARE c_tt_qty 	 DECIMAL(13,4);
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT DISTINCT a.sysdocnum,a.stockcode,a.pro_code,a.trn_qty FROM  pos_tbl_transactions as a 
	 											  where a.branchcode =v_branchcode and a.stockcode =v_stock and a.pro_code = v_procode and DATE(a.inputdate)>=v_date  ORDER BY a.sysdocnum ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_sysdocnum, c_stockcode ,c_pro_code,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	   END IF;
	   
	   IF (existing='' OR existing IS NULL )THEN
	   	 SET c_tt_qty=IFNULL((SELECT a.trn_qty_tt FROM  pos_tbl_transactions as a where a.branchcode =v_branchcode and a.pro_code = v_procode and DATE(a.inputdate)<v_date ORDER BY a.inputdate DESC  LIMIT 1),0);  
	   	 SET c_tt_qty=c_tt_qty+c_qty;
	   ELSE 
	 	 SET c_tt_qty=c_tt_qty+c_qty;
	   END IF; 
	 
	   
	  	UPDATE pos_tbl_transactions as a 
	  		SET a.trn_qty_tt=c_tt_qty
	  	where a.branchcode =v_branchcode and a.stockcode =v_stock and a.pro_code = v_procode and a.sysdocnum=c_sysdocnum;
	  	
	  	SET existing=c_sysdocnum;
	  
	  END LOOP;
	  CLOSE cursor_i;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_return_invoices` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_referent` VARCHAR(200), IN `v_remark` VARCHAR(50), IN `v_procode` VARCHAR(20), IN `v_stockcode` VARCHAR(20), IN `v_up` DECIMAL(13,4), IN `v_qty` DECIMAL(13,4), IN `v_discount` DECIMAL(13,4), IN `v_amount` DECIMAL(13,4), IN `v_token` VARCHAR(200), IN `v_inputter` VARCHAR(200))  BEGIN
	DECLARE v_invoice 	varchar(20);
	DECLARE v_sysdonum 	varchar(20);
	DECLARE vexsisting 	varchar(20);
	DECLARE v_cus_id 	varchar(20);
 


	DECLARE v_pro_cost 		DECIMAL(13,4);
	DECLARE v_pro_barcode 	varchar(50);

	SET v_cus_id=IFNULL((SELECT a.cus_id FROM  pos_tbl_invoices as a where a.branchcode=v_branchcode and a.inv_num=v_referent ORDER by a.inputdate desc limit 1),'') ;
	

	IF (v_status = 'I') THEN
	
		SET vexsisting= IFNULL((SELECT sys_token FROM pos_tbl_una_invoice_return as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		
		IF (vexsisting='')THEN
		
			CALL gb_next_id_branch(v_branchcode,'pos_invoice', '0', v_invoice);
			
			INSERT INTO pos_tbl_una_invoice_return (inv_num,cus_id,branchcode,inv_date,inv_exchange,inv_referent,inv_reason ,inputter,inputdate,sys_token) 
						values (v_invoice,v_cus_id,v_branchcode,now(),'4100',v_referent,v_remark,v_inputter,NOW(),v_token);

		END IF;
	
			SET v_invoice= IFNULL((SELECT a.inv_num FROM pos_tbl_una_invoice_return as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
			SET v_pro_cost=IFNULL(( SELECT a.pro_cost FROM pos_tbl_products as a WHERE a.branchcode=v_branchcode and a.pro_id=v_procode ORDER BY a.pro_id LIMIT 1),0); 
			SET v_pro_barcode=IFNULL(( SELECT a.barcode FROM pos_tbl_products as a WHERE a.branchcode=v_branchcode and a.pro_id=v_procode ORDER BY a.pro_id LIMIT 1),0); 
		
			CALL gb_next_id_branch(v_branchcode,'pos_invoice_sysdonum', '0', v_sysdonum);
		
			INSERT INTO pos_tbl_una_stockout_return (sto_num,branchcode,inv_num,pro_code,pro_barcode,stock_code,pro_cost,pro_qty,pro_up,pro_discount,pro_amount)
						values (v_sysdonum,v_branchcode,v_invoice,v_procode,v_pro_barcode,v_stockcode,v_pro_cost,v_qty,v_up,v_discount,v_amount);
		
	END IF;

	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_return_invoice_post` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
	 	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT DISTINCT  a.pro_code , a.pro_barcode , a.stock_code ,a.pro_qty  FROM pos_tbl_stockout_return as a where a.branchcode =v_branchcode and a.inv_num =v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,c_stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	    CALL proc_pos_post_transaction ('return_invoice',v_branchcode,v_id,c_pro_code, c_barcode ,c_stockcode,c_qty,v_inputter);
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,c_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;
	 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_stock_transfer_post` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
		DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE f_stockcode  VARCHAR(50);
    DECLARE t_stockcode  VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT DISTINCT  b.pro_code, b.barcode , a.f_stock,a.t_stock ,b.qty 
	 							  FROM pos_tbl_stocktransfer as a 
	 							  INNER JOIN pos_tbl_stocktransfer_detail as b on a.branchcode =b.branchcode and a.tran_code=b.tran_code
	 							  where a.branchcode =v_branchcode and a.tran_code =v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,f_stockcode,t_stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	    CALL proc_pos_post_transaction ('f_stocktransfer',v_branchcode,v_id,c_pro_code, c_barcode ,f_stockcode,c_qty,v_inputter);
	    CALL proc_pos_post_transaction ('t_stocktransfer',v_branchcode,v_id,c_pro_code, c_barcode ,t_stockcode,c_qty,v_inputter);
	   
	   
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,f_stockcode,c_date);
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,t_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_pos_transaction` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_id` VARCHAR(20), IN `v_inputter` VARCHAR(50))  BEGIN
 	DECLARE cursor_ID    VARCHAR(50);
  	DECLARE c_pro_code   VARCHAR(50);
  	DECLARE c_barcode    VARCHAR(50);
    DECLARE c_stockcode  VARCHAR(50);
    DECLARE c_qty 		 VARCHAR(50);
    DECLARE c_date 		 DATE;
  	DECLARE done INT DEFAULT FALSE;

	
	  DECLARE cursor_i CURSOR FOR SELECT  a.pro_code , a.barcode , a.stockcode ,a.pro_qty  FROM pos_tbl_purchase_details as a where a.branchcode =v_branchcode and a.pur_id=v_id ;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	  OPEN cursor_i;
	  	read_loop: LOOP
	    FETCH cursor_i INTO c_pro_code, c_barcode ,c_stockcode,c_qty;
	    
	   IF done THEN
	      LEAVE read_loop;
	    END IF;
	 	SET c_date=DATE(NOW());
	
	    CALL proc_pos_post_transaction ('purchaseorder',v_branchcode,v_id,c_pro_code, c_barcode ,c_stockcode,c_qty,v_inputter);
	    Call proc_pos_referesh_by_stock ('auto',v_branchcode,c_pro_code,c_stockcode,c_date);
	   
	  END LOOP;
	  CLOSE cursor_i;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_register_branch` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(255), IN `v_system` VARCHAR(255), IN `v_branch_name` VARCHAR(255), IN `v_user_name` VARCHAR(255), IN `v_Hash_password` VARCHAR(255), IN `v_Password` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
	  	 DECLARE v_subofbranch varchar(50);
  	  DECLARE vsubm_id 		varchar(50);
  	  DECLARE vsubofbranch 	varchar(50);
  	  DECLARE vbranchcode 	varchar(50);
  	  DECLARE v_user_id 	varchar(50);

 	  
  	  IF (v_status = 'I') THEN
  	  
  	  
		CALL GB_MODIFY_NEXT_ID('branchcode', '1', vsubofbranch);
		CALL GB_MODIFY_NEXT_ID('branchcode', '1', vbranchcode);

		CALL gb_next_id_branch(vbranchcode,'user_id', '1', v_user_id);
	
		
		INSERT INTO gb_sys_branch (branchcode,subofbranch,branchname,setname,inactive,trandate,inputter ,country,phone,email,website,branchshort)
			   values (vsubofbranch,vsubofbranch,CONCAT(v_branch_name, '-','PO'),CONCAT(v_branch_name, '-','PO'),'0',NOW(),v_inputter,'855','','','',v_branch_name);
		
		INSERT INTO gb_sys_branch (branchcode,subofbranch,branchname,setname,inactive,trandate,inputter,country,phone,email,website,branchshort)
			   values (vbranchcode,vsubofbranch,v_branch_name,v_branch_name,'0',NOW(),v_inputter,'855','','','',v_branch_name);
		
		CALL proc_add_users ('I',v_user_id,vbranchcode,vsubofbranch,'None',v_user_name,v_Password,v_Hash_password,'0',v_system,'N/A','0','admin','admin','IT.SYSTEM');
		
			 
	 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_register_branch_full` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(255), IN `v_branch_name` VARCHAR(255), IN `v_full_name` VARCHAR(255), IN `v_shot_name` VARCHAR(255), IN `v_inactive` VARCHAR(255), IN `v_phone` VARCHAR(255), IN `v_email` VARCHAR(255), IN `v_website` VARCHAR(255), IN `v_address` VARCHAR(255), IN `v_inputter` VARCHAR(255))  BEGIN
	  DECLARE v_subofbranch varchar(50);
  	  DECLARE vsubm_id varchar(50);
  	  set v_subofbranch= ifnull(( select a.subofbranch from gb_sys_branch a where a.branchcode=v_branchcode order by branchcode limit 1 ),'000');
  	 
  	  IF (v_status = 'I') THEN

		CALL GB_MODIFY_NEXT_ID('branchcode', '1', vsubm_id);
		
		INSERT INTO gb_sys_branch (branchcode,subofbranch,branchname,setname,inactive,trandate,inputter ,country,phone,email,website,branchshort,address)
			   values (vsubm_id,v_subofbranch,v_branch_name,v_branch_name,'0',NOW(),v_inputter,'855',v_phone,v_email,v_website,v_shot_name,v_address);

	 ELSEIF (v_status = 'U') THEN

	 	UPDATE gb_sys_branch  AS a set
	 		   a.setname=v_branch_name,
	 		   a.branchshort=v_shot_name,
	 		   a.branchname=v_full_name,
	 		   a.inactive =v_inactive,
	 		   a.phone=v_phone,
	 		   a.website=v_website,
	 		   a.email=v_email,
	 		   a.address=v_address

	 	WHERE a.branchcode=v_branchcode ;


	 END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_reset_pwd_user` (IN `v_status` VARCHAR(25), IN `v_user_id` VARCHAR(255), IN `v_branchcode` VARCHAR(50), IN `v_password` VARCHAR(5000), IN `v_pwd_salt` VARCHAR(5000), IN `v_inputter` VARCHAR(255))  BEGIN
	 	 IF (v_status = 'Resetpwd') THEN
		 	
		 
		 	INSERT INTO His_gb_sys_users (user_id,branchcode,username,password,salt,inputter ,trandate) 
		 				SELECT id ,branchcode,email,password ,salt,inputter ,NOW() 
		 				FROM gb_sys_users as a 
		 				WHERE a.id =v_user_id AND a.branchcode=v_branchcode;
		 	
		 	UPDATE gb_sys_users SET password =v_password,
		 		   salt =v_pwd_salt
		 	WHERE id=v_user_id AND branchcode=v_branchcode ;
		 
		 END IF;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_sub_left_menu` (IN `s` CHAR(20))  BEGIN
SELECT
  *
FROM tbl_sub_left_menu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_coffee_add_product` (IN `v_status` VARCHAR(25), IN `v_code` VARCHAR(25), IN `v_branchcode` VARCHAR(10), IN `v_token` VARCHAR(100), IN `v_inputter` VARCHAR(255), IN `v_barcode` VARCHAR(20), IN `v_name` VARCHAR(250), IN `v_inactive` VARCHAR(10), IN `v_type` VARCHAR(20), IN `v_line_size` VARCHAR(20), IN `v_cost` DECIMAL(13,4), IN `v_up` DECIMAL(13,4), IN `v_discount` DECIMAL(13,4), IN `v_coupon` DECIMAL(13,4))  begin
	DECLARE vsubm_id 	varchar(50);
	DECLARE vsysdocnum 	varchar(50);
	DECLARE vexsisting 	varchar(50);

	IF (v_status = 'I') THEN

		SET vexsisting= IFNULL((SELECT pro_id FROM coffee_tbl_products as a where a.branchcode =v_branchcode and a.sys_token=v_token order by a.sys_token LIMIT 1),'');
		IF (vexsisting='')THEN
			CALL gb_next_id_branch(v_branchcode,'coffee_item', '1', vsubm_id);
			CALL gb_next_id_branch(v_branchcode,'coffee_size', '9', vsysdocnum);
		
			SET v_code=vsubm_id;
			
			INSERT INTO coffee_tbl_products (pro_id, barcode, branchcode, pro_name, inactive, category, cost, unitprice, discount, currency,sys_token, inputter, inputdate)
						VALUES(v_code, v_barcode,v_branchcode, v_name, v_inactive, v_type, 0, 0, 0, '01',v_token, v_inputter, now());
		else
			SET v_code=vexsisting;
			CALL gb_next_id_branch(v_branchcode,'coffee_size', '9', vsysdocnum);
		END IF;
		
		INSERT INTO coffee_tbl_product_size (sysdocnum, pro_id, branchcode, sizecode, coupon, inactive, cost, unitprice, discount, inputter, inputdate)
				VALUES(vsysdocnum, v_code, v_branchcode, v_line_size, v_coupon, 0, v_cost, v_up, v_discount, v_inputter, now());

	END IF;

	SELECT v_code AS trancode;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_get_userinfor` (IN `v_user_name` NVARCHAR(200), IN `v_user_pwd` NVARCHAR(200))  BEGIN

SELECT
  ksu.id,
  ksu.username,
  ksu.password,
  ksu.salt,
  ksu.name,
  ksu.conpassword,
  ksu.supper,
  ksu.branchcode,
  ksu.contact,
  IFNULL(ksb.subofbranch, '') AS subofbranch,
  ksu.systemid,
  IFNULL(ksc.sys_con_name, '') AS pro_system
FROM kqr_sys_users ksu
  LEFT JOIN kqr_sys_branch ksb
    ON ksu.branchcode = ksb.branchcode
  LEFT JOIN kqr_system_controls ksc
    ON ksu.systemid = ksc.sys_con_id
WHERE ksu.username = v_user_name
AND ksu.password = v_user_pwd;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_kqr_get_profile_user` (IN `v_userid` VARCHAR(25))  BEGIN

  DECLARE vstatus varchar(50);
  IF ( SELECT
    COUNT(*)
  FROM kqr_admin_profile_user kapu
  WHERE kapu.user_login_id = v_userid) <= 0 THEN

    SET vstatus = 'user_profile';

  END IF;


SELECT
  vstatus AS status;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_land_get_items` (IN `v_id` VARCHAR(255), IN `v_branchcode` VARCHAR(255), IN `v_item_type` VARCHAR(255))  BEGIN
DECLARE vsubm_id varchar(50);
  DECLARE v_type varchar(50);


  IF (v_item_type = 'Type') THEN
    SET v_type = '0';
  ELSEIF (v_item_type = 'Size') THEN
    SET v_type = '1';
  ELSEIF (v_item_type = 'Street') THEN
    SET v_type = '2';
  ELSEIF (v_item_type = 'Plan') THEN
    SET v_type = '3';
  ELSEIF (v_item_type = 'Expend') THEN
    SET v_type = '4';
  ELSEIF (v_item_type = 'Income') THEN
    SET v_type = '5';
  ELSE
    SET v_type = '';
  END IF;

	SELECT
	  kli.item_id,
	  kli.branchcode,
	  kli.item_name,
	  kli.item_type,
	  CASE WHEN kli.item_type = '0' THEN 'Type' WHEN kli.item_type = '1' THEN 'Size' WHEN kli.item_type = '2' THEN 'Street' WHEN kli.item_type = '3' THEN 'Plan' WHEN kli.item_type = '4' THEN 'Expend' END AS type,
	  kli.item_inactive,
	  case when  kli.item_inactive='1' THEN 'YES' ELSE 'NO' END as status,
	  kli.item_remark,
	  kli.inputter ,
	  ad.id as id_location,
	  ad.eng_name  as item_location,
	  ad.khm_name 
	FROM kqr_land_items kli
	LEFT JOIN kqr_sys_address as ad on kli.item_location=ad.id 
	WHERE kli.item_id LIKE CONCAT('%', v_id, '%')
	AND kli.item_type LIKE CONCAT('%', v_type, '%')
	AND kli.branchcode = v_branchcode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_sys_login` (IN `v_username` VARCHAR(250))  NO SQL
SELECT a.id,
	   a.name ,
	   a.email ,
	   a.password,
	   a.Inactive ,
	   a.salt ,
	   a.name ,
	   a.contact ,
	   a.supper ,
	   a.systemid ,
	   a.profile ,
	   a.inputter ,
	   b.branchcode ,
	   b.subofbranch ,
	   b.setname ,
	   b.branchname,
	   b.branchshort,
	   b.website 
FROM gb_sys_users a 
inner join gb_sys_branch b on a.branchcode=b.branchcode 
WHERE a.email=v_username order by a.id limit 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rpt_pos_monthly_closing` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25), IN `v_currency` VARCHAR(50), IN `v_date_from` DATE, IN `v_date_to` DATE, IN `v_inputter` VARCHAR(200))  BEGIN
	 
	IF (v_status = 'monthly') THEN
	
		DROP TABLE IF EXISTS tmp_tbl_income;
		DROP TABLE IF EXISTS tmp_tbl_expense;
	
		CREATE TEMPORARY TABLE tmp_tbl_income
		SELECT a.close_num as trancode,
		       DATE(a.close_date) as close_date,
			   SUM(a.amount) as amount
		FROM pos_tbl_income as a 
		inner join gb_tbl_currency as c on a.currency=c.currencycode 
	    WHERE  a.branchcode  	LIKE CONCAT(IFNULL(v_branchcode,'%'), '%') 
	     	   AND a.currency   LIKE CONCAT(IFNULL(v_currency,'%'), '%')
	     	   AND DATE(a.close_date) BETWEEN v_date_from AND v_date_to
	    GROUP BY a.close_num,a.close_date ;
	   
	   
	   	CREATE TEMPORARY TABLE tmp_tbl_expense
		SELECT a.close_num as trancode,
		       DATE(a.close_date) as close_date,
			   SUM(a.amount) as amount
		FROM pos_tbl_expense as a 
		inner join gb_tbl_currency as c on a.currency=c.currencycode 
	    WHERE a.branchcode  LIKE CONCAT(IFNULL(v_branchcode,'%'), '%') 
	     	   AND a.currency   LIKE CONCAT(IFNULL(v_currency,'%'), '%')
	     	   AND DATE(a.close_date) BETWEEN v_date_from AND v_date_to
	    GROUP BY a.close_num,a.close_date ;
	   
	   
	   SELECT a.trancode,
	          a.close_date,
	   	      a.amount,
	   	      CONVERT('income' , CHAR CHARACTER SET utf8) as status
	   FROM  tmp_tbl_income as a 
	   union 
	   SELECT a.trancode,
	   	      a.close_date,
	   	      a.amount,
	   	      CONVERT('expense' , CHAR CHARACTER SET utf8) as status
	   FROM  tmp_tbl_expense as a 
	   ORDER BY status DESC ;
	  
		   
	  
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `_Clear_data` ()  BEGIN
	
	DECLARE vstatus varchar(50);
	
	if(vstatus='delete')then 
	
	
		DELETE FROM  gb_number_next_by_branch  where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  His_gb_sys_users where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  gb_profile_by_branch where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  gb_profile_by_branch where branchcode not in (SELECT branchcode FROM gb_sys_branch);
	
	
		-- Land
		
		DELETE FROM tbl_land_tillers  where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  kqr_land_customers where branchcode not in (SELECT branchcode FROM gb_sys_branch);	
		DELETE FROM  kqr_land_expend where branchcode not in (SELECT branchcode FROM gb_sys_branch);	
		DELETE FROM  kqr_land_items where branchcode not in (SELECT branchcode FROM gb_sys_branch);	
		DELETE FROM  kqr_land_register_items where branchcode not in (SELECT branchcode FROM gb_sys_branch);	
		DELETE FROM  kqr_land_sale where branchcode not in (SELECT branchcode FROM gb_sys_branch);	
		DELETE FROM  kqr_land_sale_act where branchcode not in (SELECT branchcode FROM gb_sys_branch);	
	
	
		-- POS sytem
		DELETE FROM  pos_tbl_customer_type where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_customers where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_invoices where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		

		DELETE FROM  pos_tbl_pro_type where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_products where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_proline where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_purchase_details where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_purchase_order where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_stockouts where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_stocks where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_stocktransfer where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_stocktransfer_detail where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_supplier where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_transactions where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_una_invoices where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_una_purchase_details where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_una_purchase_order where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_una_stockouts where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_una_stocktransfer where branchcode not in (SELECT branchcode FROM gb_sys_branch);
		DELETE FROM  pos_tbl_una_stocktransfer_detail where branchcode not in (SELECT branchcode FROM gb_sys_branch);

	end if ;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `_Refresh_Permission_All` ()  BEGIN
	
  DECLARE cursor_ID  VARCHAR(50);
  DECLARE cursor_VAL VARCHAR(50);
  DECLARE done INT DEFAULT FALSE;
  DECLARE cursor_i CURSOR FOR SELECT branchcode ,subofbranch FROM gb_sys_branch as a ;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cursor_i;
  read_loop: LOOP
    FETCH cursor_i INTO cursor_ID, cursor_VAL;
    IF done THEN
      LEAVE read_loop;
    END IF;
 
    
   CALL _Refresh_Permission_by_branch ('',cursor_ID);
   
  END LOOP;
  CLOSE cursor_i;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `_Refresh_Permission_by_branch` (IN `v_status` VARCHAR(25), IN `v_branchcode` VARCHAR(25))  BEGIN
	
	
	DECLARE  vprofileid  varchar(10);
	DECLARE  vsystemid   varchar(20);

	SET vprofileid = (SELECT profile FROM gb_sys_users as a where branchcode=v_branchcode ORDER by a.trandate ASC LIMIT 1) ;
	SET vsystemid =  (SELECT systemid FROM gb_sys_users as a where branchcode=v_branchcode ORDER by a.trandate ASC LIMIT 1) ;
	
	
	DELETE A FROM tbl_menu_permission_branch AS A WHERE A.branchcode =v_branchcode AND A.profile_id=vprofileid;
	
	CALL proc_auto_menu_permission ('auto',v_branchcode,vprofileid,vsystemid);


	
	
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `pos_get_fee_amount` (`v_branchcode` VARCHAR(25), `v_inv_num` VARCHAR(20), `v_trancode` VARCHAR(20)) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
	
	DECLARE t_amount DECIMAL(10,2);

	SET t_amount = IFNULL(( SELECT a.amount FROM pos_tbl_fee as a WHERE a.branchcode=v_branchcode and a.inv_num=v_inv_num and a.trancode=v_trancode LIMIT 1),0);

	RETURN t_amount;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `pos_qty_in_stock` (`v_branchcode` VARCHAR(25), `v_procode` VARCHAR(20), `v_stock` VARCHAR(20)) RETURNS VARCHAR(20) CHARSET utf8 READS SQL DATA
BEGIN
	DECLARE t_qty VARCHAR(20);
	SET t_qty=IFNULL((SELECT SUM(a.trn_qty) FROM pos_tbl_transactions as a where a.branchcode=v_branchcode and a.pro_code=v_procode and a.stockcode=v_stock),0); 
    RETURN t_qty;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `pos_una_qty_in_stock` (`v_branchcode` VARCHAR(25), `v_procode` VARCHAR(20), `v_stock` VARCHAR(20)) RETURNS VARCHAR(20) CHARSET utf8 READS SQL DATA
BEGIN
	DECLARE t_qty DECIMAL(10,0);

	SET t_qty=IFNULL((SELECT SUM(a.trn_qty) FROM pos_tbl_transactions as a where a.branchcode=v_branchcode and a.pro_code=v_procode and a.stockcode=v_stock),0); 
    RETURN t_qty;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `SPLIT_STR` (`x` VARCHAR(255), `delim` VARCHAR(12), `pos` INT) RETURNS VARCHAR(255) CHARSET utf8 RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       CHAR_LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, "")$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ajax_cruds`
--

CREATE TABLE `ajax_cruds` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coffee_tbl_line`
--

CREATE TABLE `coffee_tbl_line` (
  `line_id` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `line_name` varchar(200) DEFAULT NULL,
  `inactive` varchar(10) DEFAULT NULL,
  `line_type` varchar(10) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coffee_tbl_line`
--

INSERT INTO `coffee_tbl_line` (`line_id`, `branchcode`, `line_name`, `inactive`, `line_type`, `inputter`, `inputdate`) VALUES
('0001-0001', '0001', 'Small', '0', '02', 'bongmap@gmail.com', '2021-09-08 11:30:53'),
('0001-0002', '0001', 'Medium', '0', '02', 'bongmap@gmail.com', '2021-09-08 13:52:22'),
('0001-0003', '0001', 'Coffee', '0', '01', 'bongmap@gmail.com', '2021-09-08 14:09:38'),
('0001-0004', '0001', 'Tea', '0', '01', 'bongmap@gmail.com', '2021-09-08 14:10:52'),
('0001-0005', '0001', 'Baverage', '0', '01', 'bongmap@gmail.com', '2021-09-08 14:11:09'),
('0001-0006', '0001', 'bbbbb', '1', '01', 'bongmap@gmail.com', '2021-09-08 14:11:16'),
('0001-0007', '0001', 'សសសសស', '0', '02', 'bongmap@gmail.com', '2021-09-08 15:05:24'),
('0001-0008', '0001', 'Large', '0', '02', 'bongmap@gmail.com', '2021-09-08 15:12:58'),
('0001-0009', '0001', NULL, '0', NULL, 'bongmap@gmail.com', '2021-09-10 13:54:14'),
('0001-0010', '0001', NULL, '1', NULL, 'bongmap@gmail.com', '2021-09-10 13:55:02');

-- --------------------------------------------------------

--
-- Table structure for table `coffee_tbl_products`
--

CREATE TABLE `coffee_tbl_products` (
  `pro_id` varchar(20) NOT NULL,
  `barcode` varchar(100) DEFAULT NULL,
  `branchcode` varchar(10) NOT NULL,
  `pro_name` varchar(250) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `unitprice` decimal(10,2) DEFAULT NULL,
  `discount` double(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `sys_token` varchar(200) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coffee_tbl_products`
--

INSERT INTO `coffee_tbl_products` (`pro_id`, `barcode`, `branchcode`, `pro_name`, `inactive`, `category`, `cost`, `unitprice`, `discount`, `currency`, `sys_token`, `inputter`, `inputdate`) VALUES
('0001-0009', 'T0005', '0001', 'Ice Tea', 0, '0001-0005', '0.00', '0.00', 0.00, '01', '0001-613b0b35a6612', 'bongmap@gmail.com', '2021-09-10 14:37:25'),
('0001-0010', '22', '0001', '3333', 0, '0001-0004', '0.00', '0.00', 0.00, '01', '0001-613b0b7d06090', 'bongmap@gmail.com', '2021-09-10 14:38:37'),
('0001-0011', '22222', '0001', 'sss', 1, '0001-0005', '0.00', '0.00', 0.00, '01', '0001-613d63d6b99ea', 'bongmap@gmail.com', '2021-09-12 09:20:06'),
('0001-0012', 'ttttt', '0001', 'ttttt', 0, '0001-0003', '0.00', '0.00', 0.00, '01', '0001-613ecbb3b0f4e', 'bongmap@gmail.com', '2021-09-13 10:55:31'),
('0001-0013', 'ff', '0001', 'fff', 1, '0001-0003', '0.00', '0.00', 0.00, '01', '0001-613ed2949ca3e', 'bongmap@gmail.com', '2021-09-13 11:24:52'),
('0001-0014', '433333', '0001', 'rrrr', 0, '0001-0003', '0.00', '0.00', 0.00, '01', '0001-613ed371c0b46', 'bongmap@gmail.com', '2021-09-13 11:28:33'),
('0001-0015', 'eeeeee', '0001', 'eeeeee', 1, '0001-0004', '0.00', '0.00', 0.00, '01', '0001-613ed5479c752', 'bongmap@gmail.com', '2021-09-13 11:36:23'),
('0001-0016', 'zzzz', '0001', 'zzzzzz', 0, '0001-0003', '0.00', '0.00', 0.00, '01', '0001-613ed7706ca8e', 'bongmap@gmail.com', '2021-09-13 11:45:36'),
('0001-0017', 'xxxxxxxx', '0001', 'xxxxxxxxx', 1, '0001-0004', '0.00', '0.00', 0.00, '01', '0001-613ed7c30abfb', 'bongmap@gmail.com', '2021-09-13 11:46:59'),
('0001-0018', 'ttttttt', '0001', 'ttttttttt', 1, '0001-0004', '0.00', '0.00', 0.00, '01', '0001-613ed81bc1bb9', 'bongmap@gmail.com', '2021-09-13 11:48:27');

-- --------------------------------------------------------

--
-- Table structure for table `coffee_tbl_product_size`
--

CREATE TABLE `coffee_tbl_product_size` (
  `sysdocnum` varchar(20) NOT NULL,
  `pro_id` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `sizecode` varchar(20) DEFAULT NULL,
  `coupon` varchar(20) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `cost` decimal(10,4) DEFAULT NULL,
  `unitprice` decimal(10,2) DEFAULT NULL,
  `discount` decimal(10,4) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `coffee_tbl_product_size`
--

INSERT INTO `coffee_tbl_product_size` (`sysdocnum`, `pro_id`, `branchcode`, `sizecode`, `coupon`, `inactive`, `cost`, `unitprice`, `discount`, `inputter`, `inputdate`) VALUES
('0001-0001', '0001-0009', '0001', '0001-0002', '2.0000', 0, '2.0000', '2.00', '2.0000', 'bongmap@gmail.com', '2021-09-10 14:37:25'),
('0001-0002', '0001-0009', '0001', '0001-0002', '2.0000', 0, '2.0000', '2.00', '2.0000', 'bongmap@gmail.com', '2021-09-10 14:37:25'),
('20210910-0003', '0001-0010', '0001', '0001-0008', '3.0000', 0, '3.0000', '3.00', '3.0000', 'bongmap@gmail.com', '2021-09-10 14:38:37'),
('20210910-0004', '0001-0010', '0001', '0001-0002', '2.0000', 0, '3.0000', '3.00', '22.0000', 'bongmap@gmail.com', '2021-09-10 14:38:37'),
('20210912-0005', '0001-0011', '0001', '0001-0001', '4.0000', 0, '2.0000', '2.00', '4.0000', 'bongmap@gmail.com', '2021-09-12 09:20:06'),
('20210913-0006', '0001-0012', '0001', '0001-0001', '4.0000', 0, '4.0000', '4.00', '4.0000', 'bongmap@gmail.com', '2021-09-13 10:55:31'),
('20210913-0007', '0001-0012', '0001', '0001-0002', '5.0000', 0, '5.0000', '5.00', '5.0000', 'bongmap@gmail.com', '2021-09-13 10:55:31'),
('20210913-0008', '0001-0012', '0001', '0001-0008', '6.0000', 0, '6.0000', '6.00', '6.0000', 'bongmap@gmail.com', '2021-09-13 10:55:31'),
('20210913-0009', '0001-0012', '0001', '0001-0001', '7.0000', 0, '7.0000', '7.00', '7.0000', 'bongmap@gmail.com', '2021-09-13 10:55:31'),
('20210913-0010', '0001-0013', '0001', '0001-0001', '2.0000', 0, '2.0000', '2.00', '2.0000', 'bongmap@gmail.com', '2021-09-13 11:24:52'),
('20210913-0011', '0001-0013', '0001', '0', '2.0000', 0, '2.0000', '2.00', '2.0000', 'bongmap@gmail.com', '2021-09-13 11:24:52'),
('20210913-0012', '0001-0014', '0001', '0001-0002', '7.0000', 0, '4.0000', '5.00', '6.0000', 'bongmap@gmail.com', '2021-09-13 11:28:33'),
('20210913-0013', '0001-0014', '0001', '0001-0002', '7.0000', 0, '4.0000', '5.00', '6.0000', 'bongmap@gmail.com', '2021-09-13 11:28:33'),
('20210913-0014', '0001-0014', '0001', '0001-0001', '7.0000', 0, '4.0000', '5.00', '6.0000', 'bongmap@gmail.com', '2021-09-13 11:28:33'),
('20210913-0015', '0001-0015', '0001', '0001-0001', '3.0000', 0, '3.0000', '3.00', '3.0000', 'bongmap@gmail.com', '2021-09-13 11:36:23'),
('20210913-0016', '0001-0015', '0001', '0001-0002', '4.0000', 0, '4.0000', '4.00', '4.0000', 'bongmap@gmail.com', '2021-09-13 11:36:23'),
('20210913-0017', '0001-0016', '0001', '0001-0001', '2.0000', 0, '2.0000', '2.00', '2.0000', 'bongmap@gmail.com', '2021-09-13 11:45:36'),
('20210913-0018', '0001-0016', '0001', '0001-0002', '2.0000', 0, '2.0000', '2.00', '2.0000', 'bongmap@gmail.com', '2021-09-13 11:45:36'),
('20210913-0019', '0001-0017', '0001', '0001-0001', '3.0000', 0, '23.0000', '3.00', '3.0000', 'bongmap@gmail.com', '2021-09-13 11:46:59'),
('20210913-0020', '0001-0017', '0001', '0001-0002', '3.0000', 1, '3.0000', '3.00', '3.0000', 'bongmap@gmail.com', '2021-09-13 11:46:59'),
('20210913-0021', '0001-0018', '0001', '0001-0001', '4.0000', 0, '4.0000', '4.00', '4.0000', 'bongmap@gmail.com', '2021-09-13 11:48:27'),
('20210913-0022', '0001-0018', '0001', '0001-0002', '3.0000', 1, '33.0000', '3.00', '3.0000', 'bongmap@gmail.com', '2021-09-13 11:48:27');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gb_list_percent`
--

CREATE TABLE `gb_list_percent` (
  `id` int(11) NOT NULL,
  `percent` decimal(10,0) DEFAULT NULL,
  `percent_name` varchar(255) DEFAULT '''NULL''',
  `type` varchar(25) DEFAULT '''NULL'''
) ENGINE=MyISAM AVG_ROW_LENGTH=24 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_list_percent`
--

INSERT INTO `gb_list_percent` (`id`, `percent`, `percent_name`, `type`) VALUES
(103, '0', '0%', 'land'),
(1, '1', '1%', 'land'),
(2, '2', '2%', 'land'),
(3, '3', '3%', 'land'),
(4, '4', '4%', 'land'),
(5, '5', '5%', 'land'),
(6, '6', '6%', 'land'),
(7, '7', '7%', 'land'),
(8, '8', '8%', 'land'),
(9, '9', '9%', 'land'),
(10, '10', '10%', 'land'),
(11, '11', '11%', 'land'),
(12, '12', '12%', 'land'),
(13, '13', '13%', 'land'),
(14, '14', '14%', 'land'),
(15, '15', '15%', 'land'),
(16, '16', '16%', 'land'),
(17, '17', '17%', 'land'),
(18, '18', '18%', 'land'),
(19, '19', '19%', 'land'),
(20, '20', '20%', 'land'),
(21, '21', '21%', 'land'),
(22, '22', '22%', 'land'),
(23, '23', '23%', 'land'),
(24, '24', '24%', 'land'),
(25, '25', '25%', 'land'),
(26, '26', '26%', 'land'),
(27, '27', '27%', 'land'),
(28, '28', '28%', 'land'),
(29, '29', '29%', 'land'),
(30, '30', '30%', 'land'),
(31, '31', '31%', 'land'),
(32, '32', '32%', 'land'),
(33, '33', '33%', 'land'),
(34, '34', '34%', 'land'),
(35, '35', '35%', 'land'),
(36, '36', '36%', 'land'),
(37, '37', '37%', 'land'),
(38, '38', '38%', 'land'),
(39, '39', '39%', 'land'),
(40, '40', '40%', 'land'),
(41, '41', '41%', 'land'),
(42, '42', '42%', 'land'),
(43, '43', '43%', 'land'),
(44, '44', '44%', 'land'),
(45, '45', '45%', 'land'),
(46, '46', '46%', 'land'),
(47, '47', '47%', 'land'),
(48, '48', '48%', 'land'),
(49, '49', '49%', 'land'),
(50, '50', '50%', 'land'),
(51, '51', '51%', 'land'),
(52, '52', '52%', 'land'),
(53, '53', '53%', 'land'),
(54, '54', '54%', 'land'),
(55, '55', '55%', 'land'),
(56, '56', '56%', 'land'),
(57, '57', '57%', 'land'),
(58, '58', '58%', 'land'),
(59, '59', '59%', 'land'),
(60, '60', '60%', 'land'),
(61, '61', '61%', 'land'),
(62, '62', '62%', 'land'),
(63, '63', '63%', 'land'),
(64, '64', '64%', 'land'),
(65, '65', '65%', 'land'),
(66, '66', '66%', 'land'),
(67, '67', '67%', 'land'),
(68, '68', '68%', 'land'),
(69, '69', '69%', 'land'),
(70, '70', '70%', 'land'),
(71, '71', '71%', 'land'),
(72, '72', '72%', 'land'),
(73, '73', '73%', 'land'),
(74, '74', '74%', 'land'),
(75, '75', '75%', 'land'),
(76, '76', '76%', 'land'),
(77, '77', '77%', 'land'),
(78, '78', '78%', 'land'),
(79, '79', '79%', 'land'),
(80, '80', '80%', 'land'),
(81, '81', '81%', 'land'),
(82, '82', '82%', 'land'),
(83, '83', '83%', 'land'),
(84, '84', '84%', 'land'),
(85, '85', '85%', 'land'),
(86, '86', '86%', 'land'),
(87, '87', '87%', 'land'),
(88, '88', '88%', 'land'),
(89, '89', '89%', 'land'),
(90, '90', '90%', 'land'),
(91, '91', '91%', 'land'),
(92, '92', '92%', 'land'),
(93, '93', '93%', 'land'),
(94, '94', '94%', 'land'),
(95, '95', '95%', 'land'),
(96, '96', '96%', 'land'),
(97, '97', '97%', 'land'),
(98, '98', '98%', 'land'),
(99, '99', '99%', 'land'),
(100, '100', '100%', 'land');

-- --------------------------------------------------------

--
-- Table structure for table `gb_number_next_by_branch`
--

CREATE TABLE `gb_number_next_by_branch` (
  `branchcode` varchar(10) NOT NULL,
  `line_number` varchar(45) NOT NULL,
  `num_values` varchar(45) DEFAULT NULL,
  `num_remake` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_number_next_by_branch`
--

INSERT INTO `gb_number_next_by_branch` (`branchcode`, `line_number`, `num_values`, `num_remake`) VALUES
('0001', 'coffee_item', '18', 'coffee_item'),
('0001', 'coffee_line', '10', 'coffee_line'),
('0001', 'coffee_size', '22', 'coffee_size'),
('0001', 'coffee_sysdocnum', '8', 'coffee_sysdocnum'),
('0001', 'pos_countstock', '4', 'pos_countstock'),
('0001', 'pos_customer', '1', 'pos_customer'),
('0001', 'pos_invoice', '25', 'pos_invoice'),
('0001', 'pos_invoice_sysdonum', '23', 'pos_invoice_sysdonum'),
('0001', 'pos_line', '11', 'pos_line'),
('0001', 'pos_product', '3', 'pos_product'),
('0001', 'pos_purchaseorder', '2', 'pos_purchaseorder'),
('0001', 'pos_purchase_sysdonum', '3', 'pos_purchase_sysdonum'),
('0001', 'pos_stocktransfer', '27', 'pos_stocktransfer'),
('0001', 'pos_supplier', '1', 'pos_supplier'),
('0001', 'pos_transaction', '78', 'pos_transaction'),
('0002', 'user_id', '1', 'user_id'),
('0004', 'permission_branch', '20', 'permission_branch'),
('0004', 'pos_countstock', '5', 'pos_countstock'),
('0004', 'pos_customer', '9', 'pos_customer'),
('0004', 'pos_invoice', '13', 'pos_invoice'),
('0004', 'pos_invoice_sysdonum', '13', 'pos_invoice_sysdonum'),
('0004', 'pos_line', '13', 'pos_line'),
('0004', 'pos_product', '5', 'pos_product'),
('0004', 'pos_purchaseorder', '4', 'pos_purchaseorder'),
('0004', 'pos_purchase_sysdonum', '7', 'pos_purchase_sysdonum'),
('0004', 'pos_stocktransfer', '26', 'pos_stocktransfer'),
('0004', 'pos_supplier', '4', 'pos_supplier'),
('0004', 'pos_transaction', '36', 'pos_transaction'),
('0004', 'profile_id', '2', 'profile_id'),
('0004', 'user_id', '2', 'user_id'),
('0168', 'permission_branch', '400', 'permission_branch'),
('0168', 'pos_countstock', '9', 'pos_countstock'),
('0168', 'pos_customer', '125', 'pos_customer'),
('0168', 'pos_expense', '182', 'pos_expense'),
('0168', 'pos_fee', '26', 'pos_fee'),
('0168', 'pos_file', '156', 'pos_file'),
('0168', 'pos_invoice', '145', 'pos_invoice'),
('0168', 'pos_invoice_sysdonum', '151', 'pos_invoice_sysdonum'),
('0168', 'pos_line', '35', 'pos_line'),
('0168', 'pos_product', '48', 'pos_product'),
('0168', 'pos_purchaseorder', '12', 'pos_purchaseorder'),
('0168', 'pos_purchase_sysdonum', '22', 'pos_purchase_sysdonum'),
('0168', 'pos_stocktransfer', '181', 'pos_stocktransfer'),
('0168', 'pos_supplier', '3', 'pos_supplier'),
('0168', 'pos_transaction', '430', 'pos_transaction'),
('0168', 'profile_id', '3', 'profile_id'),
('0168', 'quote_code', '31', 'quote_code'),
('0168', 'user_id', '4', 'user_id'),
('0170', 'user_id', '1', 'user_id'),
('0172', 'user_id', '1', 'user_id');

-- --------------------------------------------------------

--
-- Table structure for table `gb_profile_by_branch`
--

CREATE TABLE `gb_profile_by_branch` (
  `profileid` varchar(25) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `profilename` varchar(50) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_profile_by_branch`
--

INSERT INTO `gb_profile_by_branch` (`profileid`, `branchcode`, `profilename`, `inactive`, `trandate`, `inputter`) VALUES
('0001-0000', '0001', 'User admin', 0, '2020-12-30 21:05:59', 'bongmap@gmail.com'),
('0004-0001', '0004', 'Supper admin', 0, '2021-03-29 16:11:34', 'IT.SYSTEM'),
('0004-0002', '0004', 'Stock User', 0, '2021-03-29 10:05:19', 'technodemo@gmail.com'),
('0168-0001', '0168', 'Supper admin', 0, '2021-03-29 09:48:30', 'IT.SYSTEM'),
('0168-0002', '0168', 'Stock User', 0, '2021-03-29 09:51:43', 'TECHNOZOON@gmail.com'),
('0168-0003', '0168', 'Sale User', 0, '2021-03-29 09:51:58', 'TECHNOZOON@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `gb_system_controls`
--

CREATE TABLE `gb_system_controls` (
  `sys_con_id` varchar(10) NOT NULL,
  `sys_con_name` varchar(50) DEFAULT '''NULL''',
  `sys_con_inactive` int(11) DEFAULT NULL,
  `sys_con_short_name` varchar(25) DEFAULT '''NULL''',
  `sys_con_effective` datetime DEFAULT NULL,
  `sys_con_remark` varchar(255) DEFAULT '''NULL''',
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=49 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_system_controls`
--

INSERT INTO `gb_system_controls` (`sys_con_id`, `sys_con_name`, `sys_con_inactive`, `sys_con_short_name`, `sys_con_effective`, `sys_con_remark`, `inputter`, `inputdate`) VALUES
('20', 'LAND SYTEM', 0, 'LAD', '2021-01-01 00:00:00', NULL, 'IT.SYSTEM', '2020-11-15 21:15:08'),
('10', 'HOSPITAL SYSTEM', 0, 'HMS', '2021-01-01 00:00:00', 'w', 'IT.SYSTEM', '2020-11-15 21:15:40'),
('30', 'POS SYSTEM', 0, 'POS', '2020-11-15 00:00:00', 'z', 'IT.SYSTEM', '2020-11-15 21:15:58'),
('40', 'COFFEE SYSTEM', 0, 'COF', '2021-01-01 00:00:00', NULL, 'bongmap@gmail.com', '2020-12-12 21:59:41');

-- --------------------------------------------------------

--
-- Table structure for table `gb_sys_branch`
--

CREATE TABLE `gb_sys_branch` (
  `branchcode` varchar(20) NOT NULL,
  `subofbranch` varchar(20) NOT NULL DEFAULT '''NULL''',
  `branchname` varchar(255) DEFAULT '''NULL''',
  `setname` varchar(50) DEFAULT NULL,
  `branchshort` varchar(255) DEFAULT '''NULL''',
  `inactive` int(11) DEFAULT NULL,
  `trandate` datetime NOT NULL,
  `phone` varchar(255) DEFAULT '''NULL''',
  `email` varchar(50) DEFAULT '''NULL''',
  `website` varchar(255) DEFAULT '''NULL''',
  `address` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=98 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_sys_branch`
--

INSERT INTO `gb_sys_branch` (`branchcode`, `subofbranch`, `branchname`, `setname`, `branchshort`, `inactive`, `trandate`, `phone`, `email`, `website`, `address`, `inputter`, `country`) VALUES
('0001', '0002', 'Technozoon company', 'HMS', 'TOZ', 0, '2019-09-18 21:33:03', '010500313', 'bongmap@gmail.com', 'www.khmerqr.com', 'រាជធានីភ្នំពេញ / ខណ្ឌឫស្សីកែវ / សង្កាត់គីឡូម៉ែត្រលេខ៦/ក្រោលគោ ផ្លូវបេតុង ក្រុម ១៣', 'abc', '855'),
('0004', '0003', 'technodemo', 'technodemo', 'technodemo', 0, '2021-03-29 16:11:34', '', '', '', 'រាជធានីភ្នំពេញ / ខណ្ឌឫស្សីកែវ / សង្កាត់គីឡូម៉ែត្រលេខ៦/ក្រោលគោ ផ្លូវបេតុង ក្រុម ១៣', 'IT.SYSTEM', '855'),
('0003', '0003', 'technodemo-PO', 'technodemo-PO', 'technodemo', 0, '2021-03-29 16:11:34', '', '', '', 'រាជធានីភ្នំពេញ / ខណ្ឌឫស្សីកែវ / សង្កាត់គីឡូម៉ែត្រលេខ៦/ក្រោលគោ ផ្លូវបេតុង ក្រុម ១៣', 'IT.SYSTEM', '855'),
('0167', '0167', 'TECHNOZOON-PO', 'TECHNOZOON-PO', 'TECHNOZOON', 0, '2021-03-29 09:48:30', '', '', '', 'រាជធានីភ្នំពេញ / ខណ្ឌឫស្សីកែវ / សង្កាត់គីឡូម៉ែត្រលេខ៦/ក្រោលគោ ផ្លូវបេតុង ក្រុម ១៣', 'IT.SYSTEM', '855'),
('0168', '0167', 'Technozoon Computer', 'TECHNOZOON', 'TEZ', 0, '2021-03-29 09:48:30', '070500987 / 077 500 987', 'technozooncambodia@gmail.com', 'www.technozoon.com', 'រាជធានីភ្នំពេញ / ខណ្ឌឫស្សីកែវ / សង្កាត់គីឡូម៉ែត្រលេខ៦/ក្រោលគោ ផ្លូវបេតុង ក្រុម ១៣', 'IT.SYSTEM', '855'),
('0169', '0169', 'bMoKBGkWXmyF-PO', 'bMoKBGkWXmyF-PO', 'bMoKBGkWXmyF', 0, '2021-08-11 21:09:38', '', '', '', NULL, 'IT.SYSTEM', '855'),
('0170', '0169', 'bMoKBGkWXmyF', 'bMoKBGkWXmyF', 'bMoKBGkWXmyF', 0, '2021-08-11 21:09:38', '', '', '', NULL, 'IT.SYSTEM', '855'),
('0171', '0171', 'land168-PO', 'land168-PO', 'land168', 0, '2021-08-12 15:33:18', '', '', '', NULL, 'IT.SYSTEM', '855'),
('0172', '0171', 'land168', 'land168', 'land168', 0, '2021-08-12 15:33:18', '078500313', 'land@gmail.com', 'www.land168.com', NULL, 'IT.SYSTEM', '855');

-- --------------------------------------------------------

--
-- Table structure for table `gb_sys_contants`
--

CREATE TABLE `gb_sys_contants` (
  `con_name` varchar(50) NOT NULL,
  `con_values` varchar(255) DEFAULT '''NULL''',
  `con_remake` varchar(255) DEFAULT '''NULL'''
) ENGINE=MyISAM AVG_ROW_LENGTH=34 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_sys_contants`
--

INSERT INTO `gb_sys_contants` (`con_name`, `con_values`, `con_remake`) VALUES
('sum_menu', '41', 'sum_menu'),
('permission_menu', '494', 'permission_menu'),
('main_menu', '16', 'main_menu'),
('branchcode', '172', 'branchcode'),
('gb_permission', '388', 'gb_permission');

-- --------------------------------------------------------

--
-- Table structure for table `gb_sys_contant_fix`
--

CREATE TABLE `gb_sys_contant_fix` (
  `con_name` varchar(50) NOT NULL,
  `con_value` varchar(255) NOT NULL DEFAULT '''NULL''',
  `con_display` varchar(255) DEFAULT '''NULL'''
) ENGINE=MyISAM AVG_ROW_LENGTH=34 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_sys_contant_fix`
--

INSERT INTO `gb_sys_contant_fix` (`con_name`, `con_value`, `con_display`) VALUES
('gender', '01', 'Male'),
('gender', '02', 'Female'),
('quote', '01', 'General Quote'),
('quote', '02', 'Love Quote'),
('quote', '03', 'Life Quote'),
('quote', '04', 'Sad Quote'),
('inactive', '1', 'Yes'),
('coffee_coupon', '5', '5-Coupon'),
('coffee_coupon', '4', '4-Coupon'),
('coffee_coupon', '3', '3-Coupon'),
('coffee_coupon', '2', '2-Coupon'),
('coffee_coupon', '1', '1-Coupon'),
('coffee_coupon', '0', '0-Coupon'),
('coffee', '01', 'Category'),
('coffee', '02', 'Size'),
('inactive', '0', 'No');

-- --------------------------------------------------------

--
-- Table structure for table `gb_sys_users`
--

CREATE TABLE `gb_sys_users` (
  `id` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `email` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  `password` varchar(5000) COLLATE latin1_general_ci DEFAULT NULL,
  `Inactive` int(11) DEFAULT NULL,
  `salt` varchar(5000) COLLATE latin1_general_ci DEFAULT NULL,
  `name` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `contact` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `conpassword` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `supper` int(11) NOT NULL,
  `branchcode` varchar(20) COLLATE latin1_general_ci NOT NULL,
  `subofbranch` varchar(20) COLLATE latin1_general_ci DEFAULT NULL,
  `systemid` varchar(25) COLLATE latin1_general_ci DEFAULT NULL,
  `profile` varchar(25) COLLATE latin1_general_ci DEFAULT NULL,
  `lastworking` datetime DEFAULT NULL,
  `inputter` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=61 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `gb_sys_users`
--

INSERT INTO `gb_sys_users` (`id`, `email`, `password`, `Inactive`, `salt`, `name`, `contact`, `conpassword`, `supper`, `branchcode`, `subofbranch`, `systemid`, `profile`, `lastworking`, `inputter`, `trandate`) VALUES
('0001', 'joincoder@gmail.com', '$2y$10$sOv90iucppy5VV6SAoRzs.h3gHqF4.2e5uDWuHtPKU2Fx9MFksOG2', 0, '$2y$10$x5AQQjzCpC5z9e81ur39Z.BDsVbDzXtxZT5SKxAPsTEI4SkEKLfvy', 'Admin Control', '010500313', 'db53f9a363967497a35ea959a5ad23fe911d32814aa0ccaccac124ccd99d28e1', 1, '0001', '0002', '20', '0001', NULL, 'rrrr', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gb_sys_user_info`
--

CREATE TABLE `gb_sys_user_info` (
  `id` varchar(10) COLLATE latin1_general_ci NOT NULL,
  `countrycode` varchar(10) COLLATE latin1_general_ci DEFAULT NULL,
  `gender` varchar(10) COLLATE latin1_general_ci DEFAULT NULL,
  `Bio` varchar(250) CHARACTER SET utf8mb4 DEFAULT NULL,
  `photo` varchar(25) COLLATE latin1_general_ci DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=61 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `gb_sys_user_info`
--

INSERT INTO `gb_sys_user_info` (`id`, `countrycode`, `gender`, `Bio`, `photo`, `trandate`) VALUES
('0001', '01', '01', 'Supper Admin', '0001_0VzBW.png', '2021-08-06 03:58:55'),
('0168-0001', '01', '01', 'Developer Technozoon', '0168-0001_vdR5F.png', '2021-08-06 04:00:14'),
('0172-0001', '01', '01', 'Supper admin', '0172-0001_7ytZJ.png', '2021-08-12 15:34:06');

-- --------------------------------------------------------

--
-- Table structure for table `gb_tbl_currency`
--

CREATE TABLE `gb_tbl_currency` (
  `currencycode` varchar(5) NOT NULL,
  `currencyname` varchar(45) DEFAULT NULL,
  `currencyshort` varchar(45) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_tbl_currency`
--

INSERT INTO `gb_tbl_currency` (`currencycode`, `currencyname`, `currencyshort`, `inactive`, `inputter`) VALUES
('01', 'Dollar', 'USD', 0, 'IT.SYSTEM'),
('02', 'Reil', 'KHR', 0, 'IT.SYSTEM'),
('03', 'KIP', 'KIP', 1, 'IT.SYSTEM');

-- --------------------------------------------------------

--
-- Table structure for table `gb_tbl_permission`
--

CREATE TABLE `gb_tbl_permission` (
  `per_id` varchar(20) NOT NULL,
  `menu_id` varchar(20) NOT NULL,
  `systemid` varchar(25) DEFAULT NULL,
  `pro_id` varchar(20) NOT NULL,
  `views` tinyint(4) DEFAULT NULL,
  `booking` tinyint(4) DEFAULT NULL,
  `edit` tinyint(4) DEFAULT NULL,
  `deletes` tinyint(4) DEFAULT NULL,
  `keytoken` varchar(45) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_tbl_permission`
--

INSERT INTO `gb_tbl_permission` (`per_id`, `menu_id`, `systemid`, `pro_id`, `views`, `booking`, `edit`, `deletes`, `keytoken`, `inputter`, `inputdate`) VALUES
('0172', '0002', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0173', 'SUB0001', '30', 'P00005', 0, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0174', 'SUB0002', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0175', 'SUB0008', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0176', 'SUB0009', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0177', 'SUB0010', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0178', 'SUB0011', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0179', 'SUB0012', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0180', 'SUB0013', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0181', 'SUB0024', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0182', '0003', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0183', 'SUB0015', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0184', 'SUB0017', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0185', 'SUB0020', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0186', 'SUB0029', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0187', '0009', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0188', 'SUB0026', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:30'),
('0189', 'SUB0031', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0190', 'SUB0032', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0191', 'SUB0033', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0192', 'SUB0034', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0193', 'SUB0035', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0194', 'SUB0036', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0195', 'SUB0037', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0196', 'SUB0038', '30', 'P00005', 1, 0, 0, 0, '610ab296eef05', 'bongmap@gmail.com', '2021-08-04 15:30:31'),
('0225', '0003', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0226', 'SUB0015', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0227', 'SUB0017', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0228', 'SUB0020', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0229', 'SUB0023', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0230', 'SUB0029', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0231', '0004', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0232', 'SUB0016', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0233', 'SUB0018', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0234', 'SUB0019', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0235', '0005', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0236', 'SUB0005', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0237', 'SUB0006', '20', 'P00020', 1, 0, 0, 0, '610e83f472f08', 'bongmap@gmail.com', '2021-08-07 13:00:36'),
('0268', '0002', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0269', 'SUB0001', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0270', 'SUB0002', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0271', 'SUB0008', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0272', 'SUB0009', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0273', 'SUB0010', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0274', 'SUB0011', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0275', 'SUB0012', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0276', 'SUB0013', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0277', 'SUB0024', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0278', '0003', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0279', 'SUB0015', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0280', 'SUB0017', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0281', 'SUB0020', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0282', 'SUB0029', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0283', '0009', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0284', 'SUB0026', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0285', 'SUB0031', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0286', 'SUB0032', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0287', 'SUB0033', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0288', 'SUB0034', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0289', 'SUB0035', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0290', 'SUB0036', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0291', 'SUB0037', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0292', 'SUB0038', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0293', '0012', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0294', 'SUB0027', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0295', 'SUB0028', '30', 'P00002', 0, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0296', '0014', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0297', 'SUB0041', '30', 'P00002', 1, 0, 0, 0, '611693394bbc8', 'bongmap@gmail.com', '2021-08-13 15:43:53'),
('0310', 'SUB0017', '30', 'P00001', 0, 0, 0, 0, '611cdeb8db83d', 'bongmap@gmail.com', '2021-08-18 10:19:36'),
('0358', '0002', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0359', 'SUB0001', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0360', 'SUB0002', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0361', 'SUB0008', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0362', 'SUB0009', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0363', 'SUB0010', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0364', 'SUB0011', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0365', 'SUB0012', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0366', 'SUB0013', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0367', 'SUB0024', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0368', '0003', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0369', 'SUB0003', '30', 'P00001', 0, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0370', 'SUB0007', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0371', 'SUB0015', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0372', 'SUB0020', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0373', 'SUB0029', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0374', '0009', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0375', 'SUB0026', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0376', 'SUB0031', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0377', 'SUB0032', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0378', 'SUB0033', '30', 'P00001', 1, 1, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0379', 'SUB0034', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0380', 'SUB0035', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0381', 'SUB0036', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0382', 'SUB0037', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0383', 'SUB0038', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0384', '0012', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0385', 'SUB0027', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0386', 'SUB0028', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0387', '0014', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32'),
('0388', 'SUB0041', '30', 'P00001', 1, 0, 0, 0, '6125e9dc72de7', 'bongmap@gmail.com', '2021-08-25 06:57:32');

-- --------------------------------------------------------

--
-- Table structure for table `gb_tbl_profile`
--

CREATE TABLE `gb_tbl_profile` (
  `pro_id` varchar(25) NOT NULL,
  `pro_name` varchar(50) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `systemid` varchar(50) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gb_tbl_profile`
--

INSERT INTO `gb_tbl_profile` (`pro_id`, `pro_name`, `inactive`, `systemid`, `trandate`, `inputter`) VALUES
('P00001', 'User Admin', 0, '30', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00002', 'User Stock', 0, '30', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00003', 'User Cashier', 0, '30', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00004', 'User Checking', 0, '30', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00005', 'User Report', 0, '30', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00010', 'User Admin', 0, '10', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00011', 'User Stock', 0, '10', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00012', 'User Cashier', 0, '10', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00013', 'User Checking', 0, '10', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00014', 'User Report', 0, '10', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00020', 'User Admin', 0, '20', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00021', 'User Authorize', 0, '20', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00022', 'User Cashier', 0, '20', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00023', 'User Checking', 0, '20', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00024', 'User Report', 0, '20', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00030', 'User Admin', 0, '40', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00031', 'User Verify', 0, '40', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00032', 'User Cashier', 0, '40', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00033', 'User Account', 0, '40', '2021-08-01 21:15:08', 'IT.SYSTEM'),
('P00034', 'User Report', 0, '40', '2021-08-01 21:15:08', 'IT.SYSTEM');

-- --------------------------------------------------------

--
-- Table structure for table `his_gb_sys_users`
--

CREATE TABLE `his_gb_sys_users` (
  `user_id` varchar(10) DEFAULT NULL,
  `branchcode` varchar(15) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(5000) DEFAULT NULL,
  `salt` varchar(5000) DEFAULT NULL,
  `inputter` varchar(250) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `his_gb_sys_users`
--

INSERT INTO `his_gb_sys_users` (`user_id`, `branchcode`, `username`, `password`, `salt`, `inputter`, `trandate`) VALUES
('0168-0002', '0168', 'stock@gmail.com', '123456$', '$2y$10$EW/s.iUsCbKOBghYEr3w/O.rZUTY.mLngu9PNyPz2zN4o1EWb7dHa', 'TECHNOZOON@gmail.com', '2021-03-29 09:55:55'),
('0004-0002', '0004', 'demo@gmail.com', '123456$', '$2y$10$ahasWhPcPMQS9pjs0ILEgurj/E5uGTwrwWjEFF46pN8ZF5K0YUjqa', 'technodemo@gmail.com', '2021-03-29 10:05:48'),
('0168-0003', '0168', 'bongratha@gmail.com', '123456$', '$2y$10$rS/yZb1APafJSQKh08ycWupUXoE7cpOU5x5QhRs6zM756YKve7KdG', 'TECHNOZOON@gmail.com', '2021-03-30 09:45:01'),
('0168-0001', '0168', 'TECHNOZOON@gmail.com', '123456', '$2y$10$CHhICWlnrwHIuoygAn0bz.GQUZBQOjC5fvSFbyNoGDX2.tH0jx7IG', 'IT.SYSTEM', '2021-03-30 13:28:12'),
('0168-0003', '0168', 'bongratha@gmail.com', '123456a$', '$2y$10$.DPAftmzlbJPlcEcWEFau.G131KsA4c18.gdFeQXPggNiyuvTUeU2', 'TECHNOZOON@gmail.com', '2021-03-30 13:36:43'),
('0168-0004', '0168', 'Sale@gmail.com', '123456$', '$2y$10$JGoZ/zGI8/bIf/2YENlJSe3rkjW6FPlV00pFP9fDEVXJ44CHOplBa', 'TECHNOZOON@gmail.com', '2021-05-03 01:28:14'),
('0001', '0001', 'bongmap@gmail.com', '$2y$10$3bM97XJ4jU42iRo.5sMq9OIRnQCJnaMo6SNJCyGmxiZEhOACJ/3fy', '$2y$10$3bM97XJ4jU42iRo.5sMq9OIRnQCJnaMo6SNJCyGmxiZEhOACJ/3fy', 'rrrr', '2021-08-06 08:23:00'),
('0001', '0001', 'bongmap@gmail.com', '$2y$10$Ax04Hdu1wppIWsk2neSTWevLE/7RoE2OujmnG12nDQUHyoueynxTK', '$2y$10$mcz3jDg0W/YPo/IK3QBvsuzhTslNOWRQsfXMGmaP4/oGb7Ce5VKfK', 'rrrr', '2021-08-06 08:23:03');

-- --------------------------------------------------------

--
-- Table structure for table `kqr_admin_branch_office`
--

CREATE TABLE `kqr_admin_branch_office` (
  `branch_code` varchar(255) NOT NULL,
  `branch_name` varchar(255) DEFAULT '''NULL''',
  `pro_id` varchar(255) DEFAULT '''NULL''',
  `sub_branchcode` varchar(255) DEFAULT '''NULL''',
  `branch_inactive` int(11) DEFAULT NULL,
  `branch_short` varchar(255) DEFAULT '''NULL''',
  `branch_inputer` varchar(255) DEFAULT '''NULL''',
  `branch_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_admin_branch_sub_office`
--

CREATE TABLE `kqr_admin_branch_sub_office` (
  `sub_branch_code` int(11) NOT NULL,
  `branch_code` int(11) NOT NULL,
  `sub_branch_name` varchar(255) DEFAULT '''NULL''',
  `sub_branch_short` varchar(255) DEFAULT '''NULL''',
  `sub_branch_inactive` varchar(255) DEFAULT '''NULL'''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_admin_profile_user`
--

CREATE TABLE `kqr_admin_profile_user` (
  `pro_id` int(11) NOT NULL,
  `user_login_id` int(11) NOT NULL,
  `sys_control_id` varchar(255) DEFAULT '''NULL''',
  `pro_name` varchar(255) DEFAULT '''NULL''',
  `pro_phone` varchar(255) DEFAULT '''NULL''',
  `pro_email` varchar(255) DEFAULT '''NULL''',
  `pro_address` varchar(255) DEFAULT '''NULL''',
  `pro_website` varchar(255) DEFAULT '''NULL''',
  `pro_logo` varchar(255) DEFAULT '''NULL''',
  `pro_inactive` int(11) DEFAULT NULL,
  `pro_trandate` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_constant`
--

CREATE TABLE `kqr_land_constant` (
  `con_name` varchar(20) NOT NULL,
  `con_value` varchar(50) DEFAULT NULL,
  `con_type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kqr_land_constant`
--

INSERT INTO `kqr_land_constant` (`con_name`, `con_value`, `con_type`) VALUES
('00%', '0', 'land_percentage'),
('01%', '1', 'land_percentage'),
('02%', '2', 'land_percentage'),
('03%', '3', 'land_percentage'),
('04%', '4', 'land_percentage'),
('05%', '5', 'land_percentage'),
('06%', '6', 'land_percentage'),
('07%', '7', 'land_percentage'),
('08%', '8', 'land_percentage'),
('09%', '9', 'land_percentage'),
('10%', '10', 'land_percentage'),
('100%', '100', 'land_percentage'),
('11%', '11', 'land_percentage'),
('12%', '12', 'land_percentage'),
('13%', '13', 'land_percentage'),
('14%', '14', 'land_percentage'),
('15%', '15', 'land_percentage'),
('16%', '16', 'land_percentage'),
('17%', '17', 'land_percentage'),
('18%', '18', 'land_percentage'),
('19%', '19', 'land_percentage'),
('20%', '20', 'land_percentage'),
('21%', '21', 'land_percentage'),
('22%', '22', 'land_percentage'),
('23%', '23', 'land_percentage'),
('24%', '24', 'land_percentage'),
('25%', '25', 'land_percentage'),
('26%', '26', 'land_percentage'),
('27%', '27', 'land_percentage'),
('28%', '28', 'land_percentage'),
('29%', '29', 'land_percentage'),
('30%', '30', 'land_percentage'),
('31%', '31', 'land_percentage'),
('32%', '32', 'land_percentage'),
('33%', '33', 'land_percentage'),
('34%', '34', 'land_percentage'),
('35%', '35', 'land_percentage'),
('36%', '36', 'land_percentage'),
('37%', '37', 'land_percentage'),
('38%', '38', 'land_percentage'),
('39%', '39', 'land_percentage'),
('40%', '40', 'land_percentage'),
('41%', '41', 'land_percentage'),
('42%', '42', 'land_percentage'),
('43%', '43', 'land_percentage'),
('44%', '44', 'land_percentage'),
('45%', '45', 'land_percentage'),
('46%', '46', 'land_percentage'),
('47%', '47', 'land_percentage'),
('48%', '48', 'land_percentage'),
('49%', '49', 'land_percentage'),
('50%', '50', 'land_percentage'),
('51%', '51', 'land_percentage'),
('52%', '52', 'land_percentage'),
('53%', '53', 'land_percentage'),
('54%', '54', 'land_percentage'),
('55%', '55', 'land_percentage'),
('56%', '56', 'land_percentage'),
('57%', '57', 'land_percentage'),
('58%', '58', 'land_percentage'),
('59%', '59', 'land_percentage'),
('60%', '60', 'land_percentage'),
('61%', '61', 'land_percentage'),
('62%', '62', 'land_percentage'),
('63%', '63', 'land_percentage'),
('64%', '64', 'land_percentage'),
('65%', '65', 'land_percentage'),
('66%', '66', 'land_percentage'),
('67%', '67', 'land_percentage'),
('68%', '68', 'land_percentage'),
('69%', '69', 'land_percentage'),
('70%', '70', 'land_percentage'),
('71%', '71', 'land_percentage'),
('72%', '72', 'land_percentage'),
('73%', '73', 'land_percentage'),
('74%', '74', 'land_percentage'),
('75%', '75', 'land_percentage'),
('76%', '76', 'land_percentage'),
('77%', '77', 'land_percentage'),
('78%', '78', 'land_percentage'),
('79%', '79', 'land_percentage'),
('80%', '80', 'land_percentage'),
('90%', '92', 'land_percentage'),
('91%', '91', 'land_percentage'),
('92%', '92', 'land_percentage'),
('93%', '93', 'land_percentage'),
('94%', '94', 'land_percentage'),
('95%', '95', 'land_percentage'),
('96%', '96', 'land_percentage'),
('97%', '97', 'land_percentage'),
('98%', '98', 'land_percentage'),
('99%', '99', 'land_percentage');

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_customers`
--

CREATE TABLE `kqr_land_customers` (
  `cus_id` varchar(25) NOT NULL,
  `branchcode` varchar(25) DEFAULT '''NULL''',
  `cus_nameeng` varchar(255) DEFAULT '''NULL''',
  `cus_namekh` varchar(255) DEFAULT '''NULL''',
  `cus_gender` varchar(255) DEFAULT '''NULL''',
  `cus_inactive` int(11) DEFAULT NULL,
  `cus_email` varchar(255) DEFAULT '''NULL''',
  `cus_phone` varchar(255) DEFAULT '''NULL''',
  `cus_address` varchar(255) DEFAULT '''NULL''',
  `cus_remark` varchar(255) DEFAULT '''NULL''',
  `inputter` varchar(200) DEFAULT NULL,
  `cus_trandate` datetime NOT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=120 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_expend`
--

CREATE TABLE `kqr_land_expend` (
  `exp_id` varchar(25) NOT NULL,
  `branchcode` varchar(255) NOT NULL,
  `exp_type` varchar(255) DEFAULT '''NULL''',
  `exp_referent` varchar(25) DEFAULT '''NULL''',
  `exp_currency` varchar(255) DEFAULT '''NULL''',
  `exp_unitprice` varchar(255) DEFAULT '''NULL''',
  `exp_remark` varchar(255) DEFAULT '''NULL''',
  `inputter` varchar(200) DEFAULT NULL,
  `exp_date` datetime NOT NULL,
  `postdate` datetime DEFAULT NULL,
  `postreferent` varchar(25) DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=84 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_items`
--

CREATE TABLE `kqr_land_items` (
  `item_id` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `branchcode` varchar(255) COLLATE latin1_general_ci NOT NULL,
  `item_name` varchar(255) COLLATE latin1_general_ci DEFAULT '''NULL''',
  `item_type` varchar(255) COLLATE latin1_general_ci DEFAULT '''NULL''',
  `item_inactive` int(11) DEFAULT NULL,
  `item_remark` varchar(255) COLLATE latin1_general_ci DEFAULT '''NULL''',
  `item_location` varchar(45) COLLATE latin1_general_ci DEFAULT NULL,
  `inputter` varchar(200) COLLATE latin1_general_ci DEFAULT NULL,
  `item_date` datetime NOT NULL,
  `c_method` float DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=55 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_register_items`
--

CREATE TABLE `kqr_land_register_items` (
  `rg_id` varchar(25) NOT NULL,
  `branchcode` varchar(25) NOT NULL,
  `rg_name` varchar(25) DEFAULT '''NULL''',
  `currency` varchar(50) DEFAULT '''NULL''',
  `inactive` int(11) DEFAULT NULL,
  `p_view` int(11) DEFAULT NULL,
  `plan_id` varchar(25) DEFAULT '''NULL''',
  `type_id` varchar(25) DEFAULT '''NULL''',
  `size_id` varchar(25) DEFAULT '''NULL''',
  `street_id` varchar(25) DEFAULT '''NULL''',
  `cost` decimal(13,2) DEFAULT NULL,
  `unitprice` decimal(13,2) DEFAULT NULL,
  `remark` varchar(255) DEFAULT '''NULL''',
  `sub_of_rg` varchar(25) DEFAULT '''NULL''',
  `inputter` varchar(200) DEFAULT NULL,
  `trandate` datetime NOT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=112 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_sale`
--

CREATE TABLE `kqr_land_sale` (
  `sal_id` varchar(25) NOT NULL,
  `rg_id` varchar(25) NOT NULL,
  `cus_id` varchar(25) NOT NULL,
  `branchcode` varchar(25) NOT NULL,
  `rg_name` varchar(25) DEFAULT '''NULL''',
  `inactive` int(11) DEFAULT NULL,
  `cost` decimal(13,2) DEFAULT NULL,
  `unitprice` decimal(13,2) DEFAULT NULL,
  `discount` decimal(13,2) DEFAULT NULL,
  `amount` decimal(13,2) DEFAULT NULL,
  `sys_amount` decimal(13,2) DEFAULT NULL,
  `remark` varchar(250) DEFAULT '''NULL''',
  `inputter` varchar(200) DEFAULT NULL,
  `trandate` datetime NOT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=120 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_land_sale_act`
--

CREATE TABLE `kqr_land_sale_act` (
  `act_id` varchar(25) NOT NULL,
  `sal_id` varchar(25) NOT NULL,
  `branchcode` varchar(25) NOT NULL,
  `reason` varchar(255) DEFAULT '''NULL''',
  `inputter` varchar(200) DEFAULT NULL,
  `trandate` datetime NOT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=120 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kqr_sys_address`
--

CREATE TABLE `kqr_sys_address` (
  `id` varbinary(25) NOT NULL,
  `khm_name` varchar(255) DEFAULT NULL,
  `eng_name` varchar(255) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=34 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kqr_sys_address`
--

INSERT INTO `kqr_sys_address` (`id`, `khm_name`, `eng_name`, `inactive`, `inputter`, `trandate`) VALUES
(0x3031, 'ខេត្តបន្ទាយមានជ័យ', 'Banteay Meanchey', 0, 'IT.SYSTEM', NULL),
(0x3032, 'ខេត្តបាត់ដំបង', 'Battambang', 0, 'IT.SYSTEM', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2020_08_05_145042_create_ajax_cruds_table', 1),
(5, '2020_10_29_022746_create_sessions_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_tbl_quotes`
--

CREATE TABLE `post_tbl_quotes` (
  `id` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `line` varchar(10) DEFAULT NULL,
  `quote` text,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `post_tbl_quotes`
--

INSERT INTO `post_tbl_quotes` (`id`, `branchcode`, `line`, `quote`, `inputter`, `inputdate`) VALUES
('0168-0005', '0168', '03', 'អ្នកណាសាងអាក្រក់ ក៏អោយគេសាងចុះ ព្រោះជាជីវិតរបស់គេ សំខាន់យើងធ្វើឲ្យល្អច្រើនៗ ក្នុងជីវិតជីវិតយើងទៅបានហើយ', 'Sale@gmail.com', '2021-08-15 05:49:57'),
('0168-0006', '0168', '03', 'គ្មានអ្នកណាដែលមិនធ្លាប់មានកំហុសនោះទេ បើខុសហើយចេះកែនោះអ្នកនឹងមានតម្លៃ', 'Sale@gmail.com', '2021-08-16 06:16:09'),
('0168-0007', '0168', '01', 'ការដែលយើងនៅស្ងៀមស្ងាត់វាប្រសើរជាងយើងតបត', 'Sale@gmail.com', '2021-08-16 06:17:13'),
('0168-0008', '0168', '03', 'កុំ ៤ យ៉ាង \r\n- កុំចុះចាញ់នឹងជីវិត\r\n- កុំរតគេចនិងបញ្ហា\r\n- កុំខ្វល់និងពាក្យនិន្ទា\r\n- កុំមើលងាយខ្លួន​​ឯង', 'Sale@gmail.com', '2021-08-16 06:19:20'),
('0168-0009', '0168', '01', 'ជីវិតនៅលីវជាពេលត្រូវខិតខំប្រឹងប្រែងកុំចំណាយពេលលើការសប្បាយច្រើនពេក', 'Sale@gmail.com', '2021-08-17 01:45:52'),
('0168-0010', '0168', '03', 'ធ្វើជាមនុស្ស បើជីវិតបានល្អប្រសើរហើយកុំបំពានជីវិតអ្នកដទៃ', 'Sale@gmail.com', '2021-08-18 01:25:23'),
('0168-0011', '0168', '03', 'ម៉ែគឺជាព្រះដែលកូនគោរព ម៉ែគឺជាម្លប់របស់កូន', 'Sale@gmail.com', '2021-08-18 06:28:27'),
('0168-0012', '0168', '02', 'ធ្វើល្អដាក់ម៉ែ មើលថែម៉ែ គោរពម៉ែ ទាន់មានម៉ែនៅ', 'sale@gmail.com', '2021-08-20 07:47:38'),
('0168-0013', '0168', '03', 'ជោគជ័មិនធ្លាក់ពីលើមេឃទេអ្នកណាប្រឹងអ្នកហ្នឹងបាន', 'sale@gmail.com', '2021-08-20 07:48:25'),
('0168-0014', '0168', '03', 'រាប់អានគ្នាដោយចិត្តនិងចិត្ត ទោះជីវិតធ្លាក់ដល់បាទ ក៏មិនប្រែប្រួលដែរ', 'sale@gmail.com', '2021-08-21 02:39:11'),
('0168-0015', '0168', '03', 'យើងកើតមកទីនេះគឺដើម្បីរៀន ហើយពិភពលោកគឺជាគ្រូបង្រៀនរបស់យើង', 'sale@gmail.com', '2021-08-22 07:13:28'),
('0168-0016', '0168', '03', 'ធ្វើជាមនុស្សកុំមើលងាយអ្នកដទៃ ព្រោះមនុស្សម្នាក់សុទ្ធតែមានតម្លៃរៀងខ្លួន', 'sale@gmail.com', '2021-08-22 07:14:55'),
('0168-0017', '0168', '03', 'កំហុសជាពន្លឺនាំផ្លូវ ខុសហើយចេះកែតម្រូវអ្នកនឹងបានល្អប្រសើរ', 'sale@gmail.com', '2021-08-24 01:23:35'),
('0168-0018', '0168', '01', 'ទោះផ្ទះធំប៉ុណ្ណាក៏ដោយ បើចិត្តមនុស្សចង្អៀតហើយពិបាករស់នៅខ្លាំងណាស់', 'sale@gmail.com', '2021-08-24 01:24:55'),
('0168-0019', '0168', '01', 'សម្ដីអាក្រក់តែចិត្តល្អ ប្រសើរជាងសម្ដីផ្អែមដូចស្ករតែចិត្តអាក្រក់', 'sale@gmail.com', '2021-08-25 09:24:07'),
('0168-0020', '0168', '01', 'កុំរៀននិយាយថាអ្នកនេះមិនល្អ​ អ្នកនោះមិនល្អ ត្រូវចាំផងថាយើងក៏មិនល្អប៉ុន្មានដែរ', 'sale@gmail.com', '2021-08-25 09:28:49'),
('0168-0021', '0168', '03', 'ចុងខែហើយសល់តែខ្លួនឯង និងវិញ្ញាណ ចំណែកលុយអស់ហើយ', 'sale@gmail.com', '2021-08-27 01:06:49'),
('0168-0022', '0168', '03', 'អាយុកាន់តែច្រើកាន់តែយល់ច្បាស់ថារឿងដែលពិបាកបំផុតនោះគឺអត់លុយចាយទេមិនមែនអត់ស្នេហានោះទេ', 'sale@gmail.com', '2021-08-27 07:03:30'),
('0168-0023', '0168', '01', 'កុំយកខួរក្បាលទៅចង់ចាំអ្វីដែលធ្វើអោយយើងកើតទុក្ខ', 'sale@gmail.com', '2021-08-29 02:19:27'),
('0168-0024', '0168', '01', 'លុយមិនអាចទិញអ្វីៗគ្រប់យ៉ាងបានទេ ប៉ុន្ដែសម័យនេះជីវិតអត់លុយជីវិតក៏វេទនាដែរ', 'sale@gmail.com', '2021-08-29 02:20:57'),
('0168-0025', '0168', '03', 'អ្នកមិនមែនធ្វើការដើម្បីមេរបស់អ្នកនោះទេ ប៉ុន្ដែអ្នកធ្វើការដើម្បីខ្លួនឯង', 'sale@gmail.com', '2021-08-29 02:24:09'),
('0168-0026', '0168', '01', 'ខ្ញុំមិនពូកែអែបអប មិនពូកែផ្អែម មិនពូកែលើកជើង មិនពូកែយកចិត្ត តែអ្វីដែលខ្ញុំធ្វើមិនមែនជាការសម្ដែងឡើយ', 'sale@gmail.com', '2021-09-01 01:45:47'),
('0168-0027', '0168', '03', 'ការលំបាកបំផុតរបស់ជីវិត គឺរៀនពេញចិត្តចំពោះអ្វីដែលខ្លួនមាន នឹងការរំដោះខ្លួនកុំឲ្យជាប់ជំពាក់នឹងរបស់អ្វីមួយឲ្យសោះ', 'sale@gmail.com', '2021-09-04 06:21:44'),
('0168-0028', '0168', '02', 'អស់កម្លាំងកាយតែ កុំអស់កម្លាំងចិត្ត គ្រប់បញ្ហាសុទ្ធតែមានច្រកចេញ សម្រាកបន្ដិចរួចចាំដំណើរទៅមុខទៀត', 'sale@gmail.com', '2021-09-04 06:24:33'),
('0168-0029', '0168', '01', 'អ្នកទិញមិនដែលសួរនាំច្រើន អ្នកសួរនាំច្រើនមិន​ដែលទិញ', 'sale@gmail.com', '2021-09-04 06:25:47'),
('0168-0030', '0168', '01', 'គេថាយើងអាក្រក់ក៏អាក្រក់ចុះ តែដាច់ខាត់យើងកុំធ្វើអាក្រក់ដូចគេនិយាយ', 'sale@gmail.com', '2021-09-04 06:26:36'),
('0168-0031', '0168', '03', 'ពាក្យថាម៉ែ ស៊ូរហាលព្យុះភ្លៀងអោយតែកូនបានសុខ', 'sale@gmail.com', '2021-09-04 06:41:51'),
('0168-90001', '0168', '01', 'រកស៊ីសន្សឹមៗកុំផ្លោះរបងចង់មានខុសទំនង់ប្រយ័ត្នលង់ខ្លួន ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900010', '0168', '01', 'ទោះជាខ្ញុំនៅក្មេងតែបើខ្ញុំដាក់ចិត្តធ្វើរឿងអ្វីមួយហើយនោះ ហើយខ្ញុំមិនឈប់ពាក់កណ្ដាលផ្លូវឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000100', '0168', '01', 'ដើមទុនជីវិតដ៏ធំបំផុតនៃជីវិត គឺភាពស្មោះត្រង់និងទំនួលខុសត្រូវ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000101', '0168', '01', 'ត្រូវចាំមនុស្សដែលចង់ទៅហើយទោះយើងខំឃាត់យ៉ាងណាក៏មិនអាចឃាត់បានដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000102', '0168', '01', 'ជ្រើសរើសយកមនុស្សដែលខ្លាចបាត់បង់យើងទើបយើងមានតម្លៃពិតក្នុងជីវិតរបស់គេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000103', '0168', '01', 'ពេលវេលាដើរលេងនិងលែងសំខាន់ពេលអ្នកមានគោលដៅច្បាស់លាស់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000104', '0168', '01', 'យកឈ្នះអ្នកដទៃគ្មានអ្វីអស្ចារ្យទេ យកឈ្នះលើខ្លួនឯងទើបជីវិតមានន័យ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000105', '0168', '01', 'ចង់ឲ្យចិត្តសប្បាយត្រូវរស់នៅឲ្យឆ្ងាយពីមនុស្សដែលធ្វើឲ្យយើងពិបាកចិត្ត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000106', '0168', '01', 'សួរស្ដីខែ កក្ដដា ជូនពរឲ្យមានសុខភាពល្អ សំណាងល្អ មានសុភមង្គល ជោគជ័យគ្រប់ផ្លូវ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000107', '0168', '01', 'បញ្ហាកើតឡើង គឺធ្វើឲ្យយើងខំប្រឹង កាន់តែខ្លាំងមិនមែនចុះចាញ់នោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000108', '0168', '01', '១ថ្ងៃដំបូងនៃខែកក្ដដាយ៉ាងមិនហើយ?', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000109', '0168', '01', 'ធ្វើជាមនុស្សត្រូវតែគិតល្អ និយាយល្អ អ្វីដែលសំខាន់យើងធ្វើតែអំពើល្អ ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900011', '0168', '01', 'ស្គាល់គ្នាយូរហើយក៏មិនប្រកដថាស្គាល់ច្បាស់ដែរ សម្ដីខ្លះផ្អែមណាស់ក៏មិនប្រាកដថាគេស្មោះនិងយើងដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000110', '0168', '01', 'ពាក្យថាមិនអីទេជាពាក្យដែលខ្ញុំប្រើគ្រប់ពេលដែលខ្ញុំជួបបញ្ហា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000111', '0168', '01', 'មនុស្សដែលតែងតែគិតពីយើងមិនថាយប់មិនថាថ្ងៃម្នាក់នោះគឺម៉ែ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000112', '0168', '01', 'មនុស្សយើងអាចគេចអ្វីបានតែគេចការពិតមិនបាននោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000113', '0168', '01', 'រស់ពឹងកម្លាំងខ្លួនឯងទោះមិនសល់ទ្រព្យច្រើនក៏ជីវិតមានន័យដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000114', '0168', '01', 'ម៉ែទោះបីគាត់បុិនរអ៊ូច្រើន តែគាត់ស្រឡាញ់យើងខ្លះបំផុត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000115', '0168', '01', 'មិត្តភក្តិមានក្ររាប់អានទាំងអស់កុំអោយតែវាយឫកដាក់ខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000116', '0168', '01', 'ជីវិតខ្ញុំអឺយកាលមុនលំបាកឥឡូវវេទនា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000117', '0168', '01', 'បើអ្នកគ្មានសំណាងបានជួបមនុស្សល្អទេ ចូលធ្វើឲ្យដូចជាមនុស្សល្អ ឲ្យអ្នកដទៃមានសំណាងបានជួបអ្នកវិញ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000118', '0168', '01', 'ធ្វើជាមនុស្សត្រូវចេះទទួលខុសត្រូវ ទាំងសម្ដីនឹងទង្វើរបស់ខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000119', '0168', '01', 'ពេលយើងក្រមិនមានអ្នកណាចង់និយាយជាមួយយើងទេ ព្រោះគេខ្លាចយើងខ្ចីលុយគេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900012', '0168', '01', 'ប្រសិនបើការងាររបស់យើងពិតជាល្អពិតមែនទោះបីមេមិនសរសើរក៏ការងារនោះមានតម្លៃសម្រាប់យើងដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000120', '0168', '01', 'គ្មានអ្វីដែលបានមកស្រួលៗទេ កុំជឿលើវាសនា ត្រូវតែជឿលើការខំប្រឹងប្រែងរបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000121', '0168', '01', 'មនុស្សទាល់តែបាត់បងគ្នាគ្មានថ្ងៃត្រឡប់ ទើបនឹកឃើញរឿងល្អៗ ដែលធ្លាប់មានជាមួយគ្នា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000122', '0168', '01', 'អ្វីដែលខ្ញុំប្រាថ្នាគឺ សុំអោយគ្រួសារខ្ញុំមានក្ដីសុខ ជៀសផុតពីជំងឺ មានសុភមង្គល និងជួបតែមនុស្សល្អៗ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000123', '0168', '01', 'ប្រដៅកូនតូចដោយប្រាប់រឿងខុសត្រូវមិនមែនចាំតម្រូវចិត្តកូនគ្រប់ពេលនោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000124', '0168', '01', 'រូបកាយស្អាតត្រឹមមួយគ្រា តែចិត្តអ្នកជាស្អាតមួយជីវិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000125', '0168', '01', 'កិត្តិយសពិតមិនបានមកពីភាពហឺុហាទេ ក៏ប៉ុន្ដែបានមកពីភាពស្មោះត្រង់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000126', '0168', '01', 'ក្ដីស្រមៃរបស់ខ្ញុំគឺឈប់ធ្វើការអោយគេ ហើយចាប់ផ្ដើមអជីវកម្មតូចដោយខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000127', '0168', '01', 'មនុស្សដែលស្និតស្នាលបំផុត មនុស្សដែលអ្នកទុកចិត្តបំផុត ក៏ជាមនុស្សដែលអ្នកគួរប្រុងប្រយ័ត្នដូចគ្នា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000128', '0168', '01', 'ខុសទើបដឹង ប្រឹងទើបបានអ្នកគ្រប់យ៉ាងដែលបានកើតឡើងគឺជាមេរៀនជីវិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000129', '0168', '01', 'ស្រឡាញ់ទឹកចិត្តអោយបានច្រើនជាងស្រឡាញ់លុយទើបសំបូរញាតិរាប់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900013', '0168', '01', 'កុំធ្វើការដើម្បីប្រាក់់ខែតែគួរតែធ្វើការដើម្បីបទពិសោធនិងជំនាញទើបជោគជ័យ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000130', '0168', '01', 'មនុស្សខ្ញុំអាក្រក់ត្រង់ថា បើគេមិនគោរពខ្ញុំ ខ្ញុំក៏មិនគោរពគេដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000131', '0168', '01', 'ជីវិតគឺបែបនេះឯង ប្រសិនបើយើងទន់ជ្រាយប្រាកដជាគេមើលងាយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000132', '0168', '01', 'ជីវិតយើងមិនជួបរឿងល្អរហូតទេ ដូច្នេះហាមបាក់ទឹកចិត្តពេលមានបញ្ហាកើតឡើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000133', '0168', '01', 'លុយសំខាន់ណាស់ តែវាមិនសំខាន់ជាងភាពស្មោះត្រង់ទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000134', '0168', '01', 'កុំរិះគន់អ្នកណាបើខ្លួនឯងមិនបានល្អលើសគេ មុននឹងយើងមើលងាយគេកុំភ្លេចមើលស្រមោលខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000135', '0168', '01', 'ការផ្លាស់ប្ដូរវាមិនស្រួលមែន តែវានិងធ្វើអោយអ្នករីកចម្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000136', '0168', '01', 'សាមញ្ញៗនឹងទ្រព្យខ្លួនឯង ប្រសើរជាងអួតសម្ញែងរកសុខមិនបាន ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000137', '0168', '01', 'ស្លៀកពាក់ថោកមែនតែចិរិកខ្ញុំមិនថោដូចការស្លៀកពាក់ទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000139', '0168', '01', 'សួរស្ដីខែ កក្ដដា ជូនពរឲ្យមានសុខភាពល្អ សំណាងល្អ មានសុភមង្គល ជោគជ័យគ្រប់ផ្លូវ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900014', '0168', '01', 'ជ័យជំនះដ៏ធំបំផុតរបស់មនុស្សគ្រប់រូបគឺយកឈ្នះចិត្តខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000140', '0168', '01', 'បញ្ហាកើតឡើង គឺធ្វើឲ្យយើងខំប្រឹង កាន់តែខ្លាំងមិនមែនចុះចាញ់នោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000141', '0168', '01', '១ថ្ងៃដំបូងនៃខែកក្ដដាយ៉ាងមិនហើយ?', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000142', '0168', '01', 'ធ្វើជាមនុស្សត្រូវតែគិតល្អ និយាយល្អ អ្វីដែលសំខាន់យើងធ្វើតែអំពើល្អ ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000143', '0168', '01', 'ពាក្យថាមិនអីទេជាពាក្យដែលខ្ញុំប្រើគ្រប់ពេលដែលខ្ញុំជួបបញ្ហា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000144', '0168', '01', 'មនុស្សដែលតែងតែគិតពីយើងមិនថាយប់មិនថាថ្ងៃម្នាក់នោះគឺម៉ែ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000145', '0168', '01', 'មនុស្សយើងអាចគេចអ្វីបានតែគេចការពិតមិនបាននោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000146', '0168', '01', 'រស់ពឹងកម្លាំងខ្លួនឯងទោះមិនសល់ទ្រព្យច្រើនក៏ជីវិតមានន័យដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000147', '0168', '01', 'ម៉ែទោះបីគាត់បុិនរអ៊ូច្រើន តែគាត់ស្រឡាញ់យើងខ្លះបំផុត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000148', '0168', '01', 'មិត្តភក្តិមានក្ររាប់អានទាំងអស់កុំអោយតែវាយឫកដាក់ខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000149', '0168', '01', 'ជីវិតខ្ញុំអឺយកាលមុនលំបាកឥឡូវវេទនា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900015', '0168', '01', 'កើតមកទទេស្លាប់ទៅវិញក៏ទទេដែររស់នៅកុំបៀតបៀនអ្នកដទៃកុំធ្វើខ្លួនឲ្យគេស្អប់ច្រើនពេក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000150', '0168', '01', 'បើអ្នកគ្មានសំណាងបានជួបមនុស្សល្អទេ ចូលធ្វើឲ្យដូចជាមនុស្សល្អ ឲ្យអ្នកដទៃមានសំណាងបានជួបអ្នកវិញ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000151', '0168', '01', 'ធ្វើជាមនុស្សត្រូវចេះទទួលខុសត្រូវ ទាំងសម្ដីនឹងទង្វើរបស់ខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000152', '0168', '01', 'ពេលយើងក្រមិនមានអ្នកណាចង់និយាយជាមួយយើងទេ ព្រោះគេខ្លាចយើងខ្ចីលុយគេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000153', '0168', '01', 'គ្មានអ្វីដែលបានមកស្រួលៗទេ កុំជឿលើវាសនា ត្រូវតែជឿលើការខំប្រឹងប្រែងរបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000154', '0168', '01', 'មនុស្សទាល់តែបាត់បងគ្នាគ្មានថ្ងៃត្រឡប់ ទើបនឹកឃើញរឿងល្អៗ ដែលធ្លាប់មានជាមួយគ្នា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000155', '0168', '01', 'អ្វីដែលខ្ញុំប្រាថ្នាគឺ សុំអោយគ្រួសារខ្ញុំមានក្ដីសុខ ជៀសផុតពីជំងឺ មានសុភមង្គល និងជួបតែមនុស្សល្អៗ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000156', '0168', '01', 'ប្រដៅកូនតូចដោយប្រាប់រឿងខុសត្រូវមិនមែនចាំតម្រូវចិត្តកូនគ្រប់ពេលនោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000157', '0168', '01', 'រូបកាយស្អាតត្រឹមមួយគ្រា តែចិត្តអ្នកជាស្អាតមួយជីវិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000158', '0168', '01', 'កិត្តិយសពិតមិនបានមកពីភាពហឺុហាទេ ក៏ប៉ុន្ដែបានមកពីភាពស្មោះត្រង់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000159', '0168', '01', 'ក្ដីស្រមៃរបស់ខ្ញុំគឺឈប់ធ្វើការអោយគេ ហើយចាប់ផ្ដើមអជីវកម្មតូចដោយខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900016', '0168', '01', 'កម្លាំងចិត្តគឺជាថ្នាំដ៏មហាសាលសម្រាប់មនុស្សដែលកំពុងបាក់ទឹកចិត្ត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000160', '0168', '01', 'មនុស្សដែលស្និតស្នាលបំផុត មនុស្សដែលអ្នកទុកចិត្តបំផុត ក៏ជាមនុស្សដែលអ្នកគួរប្រុងប្រយ័ត្នដូចគ្នា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000161', '0168', '01', 'ខុសទើបដឹង ប្រឹងទើបបានអ្នកគ្រប់យ៉ាងដែលបានកើតឡើងគឺជាមេរៀនជីវិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000162', '0168', '01', 'ស្រឡាញ់ទឹកចិត្តអោយបានច្រើនជាងស្រឡាញ់លុយទើបសំបូរញាតិរាប់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000163', '0168', '01', 'មនុស្សខ្ញុំអាក្រក់ត្រង់ថា បើគេមិនគោរពខ្ញុំ ខ្ញុំក៏មិនគោរពគេដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000164', '0168', '01', 'ជីវិតគឺបែបនេះឯង ប្រសិនបើយើងទន់ជ្រាយប្រាកដជាគេមើលងាយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000165', '0168', '01', 'ជីវិតយើងមិនជួបរឿងល្អរហូតទេ ដូច្នេះហាមបាក់ទឹកចិត្តពេលមានបញ្ហាកើតឡើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000166', '0168', '01', 'លុយសំខាន់ណាស់ តែវាមិនសំខាន់ជាងភាពស្មោះត្រង់ទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000167', '0168', '01', 'កុំរិះគន់អ្នកណាបើខ្លួនឯងមិនបានល្អលើសគេ មុននឹងយើងមើលងាយគេកុំភ្លេចមើលស្រមោលខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000168', '0168', '01', 'ការផ្លាស់ប្ដូរវាមិនស្រួលមែន តែវានិងធ្វើអោយអ្នករីកចម្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000169', '0168', '01', 'សាមញ្ញៗនឹងទ្រព្យខ្លួនឯង ប្រសើរជាងអួតសម្ញែងរកសុខមិនបាន ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900017', '0168', '01', 'ពេលមានបានកុំរើសអើងអ្នកក្រខំធ្វើរឿងល្អៗនោះជីវិតនឹងកាន់តែមានតម្លៃ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000170', '0168', '01', 'ស្លៀកពាក់ថោកមែនតែចិរិកខ្ញុំមិនថោដូចការស្លៀកពាក់ទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000171', '0168', '01', 'ទ្រំច្រើនហើយបើគេមើលមិនឃើញតម្លៃទេដើរចេញទៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000172', '0168', '01', 'ឧបសគ្គនឹងអាចក្លាយជាឳកាសថ្មី បើយើងចេះកែច្នៃដោយភាពវៃឆ្លាត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000173', '0168', '01', 'មនុស្សម្នាក់តែងតែមានភាពសម្បត្តិ និងភាពស្រស់ស្អាតផ្សេងៗគ្នា កុំមើលតែសំបកក្រៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000174', '0168', '01', 'បរុសម្នាក់ដែលឲ្យតម្លៃអ្នកនិងមិនលាក់អ្នកទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000175', '0168', '01', 'គ្រប់គ្នាដើរចូលមកជីវិតយើងសុទ្ធតែមានហេតុផលអ្នកឬអាក្រក់ ស្រឡាញ់ឬស្អប់ ស្មោះឬក្បត់ ពេលវេលានិងនិយាយប្រាប់ហើយគ្រប់ផ្នែសុទ្ធតែជាមេរៀនដែលយើងអាចរៀនបាន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000176', '0168', '01', 'សុខចិត្តរស់នៅឯកាប្រសើរជាងរស់នៅជាមួយមនុស្សដែលធ្វើឲ្យឯកា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000177', '0168', '01', 'គ្រប់យ៉ាងសុទ្ធតែអាចកើតឡើងបាន ឲ្យតែយើងដាក់ចិត្តដាក់បេះដូងធ្វើវា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000178', '0168', '01', 'ជួនពរឲ្យខ្លួនឯងមានសតិ ចិត្តត្រជាក់ជាមួយរឿងរ៉ាវដែលត្រូវជួប', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000179', '0168', '01', 'សព្វថ្ងៃបើអត់ Internet ដូចមេឃអត់ពន្លឺ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900018', '0168', '01', 'ចង់ឈប់ក្រកុំយកភាពខ្ជិលមកដាក់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000180', '0168', '01', 'ចូលកុំផ្ដល់ក្ដីស្រឡាញ់នឹងមនុស្សដែលមិនសាកសមនិងទទួលបានវា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000181', '0168', '01', 'ល្ងង់មិនមែនជាបញ្ហាធំទេ ល្ងង់ហើយមិនព្រមស្ដាប់ទេទើបជារឿងគ្រោះថ្នាក់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000182', '0168', '01', 'ពេលយប់ជាពេលដែលយើងមានឳកាសនៅជាមួយខ្លួនឯងច្រើនបំផុត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000183', '0168', '01', 'អ្នកមិនមានពិតសាមញ្ញណាស់ អ្នកមានលំៗជាន់ដីផ្អៀង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000184', '0168', '01', 'ត្រូវប្រាប់ខ្លួនឯងថា ៥ ឆ្នាំនិងត្រូវមានផ្ទះតូចមួយនិងគេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000185', '0168', '01', 'ត្រូវចាំថាមនុស្សដែលយើងគួរវាយតម្លៃមុនគេគឺខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000186', '0168', '01', 'កុំសង្ឃឹមអ្វីច្រើនពេកពីមនុស្សជុំវិញខ្លួន ព្រោះការសង្ឃឹមច្រើនពេកនឹងធ្វើឲ្យយើងខកចិត្តកាន់តែខ្លាំង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000187', '0168', '01', 'គេសេដរឿងស្នេហា ខ្ញុំវិញសេដរឿងអត់លុយចាយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000188', '0168', '01', 'ជាកូនប្រុសបើចិញ្ចឹមខ្លួនឯងមិនទាន់រស់ស្រួលកុំទាន់អាល់សុំម៉ែយកប្រពន្ធ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000189', '0168', '01', 'ការជឿទុកចិត្តពិបាកសាងណាស់តែបើវាខ្ទេចហើយពិបាកជួសជុលវិញណាស់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900019', '0168', '01', 'សូមកុំរស់ប្រើជីវិតរសើមួយថ្ងៃគិតមួយថ្ងៃតែត្រូវមានចក្ខុវិស័យវែងឆ្ងាយទៅថ្ងៃអនាឡគត់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000190', '0168', '01', 'ពេលនេះនរណាក៏ជួបការលំបាកដែរ ទ្រាំបន្ដិចទៅអ្វីៗនឹងល្អប្រសើរឆាប់ៗ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000191', '0168', '01', 'វិធីរកក្ដីសុខ  កុំដឹងច្រើន កុំរំពឹងច្រើន កុំរពឹងទុកច្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000192', '0168', '01', 'កុំខ្លាចការចាប់ផ្ដើមថ្មីជួនកាល់យើងអាចទៅបានឆ្ងាយជាងមុន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000193', '0168', '01', 'ទោះមិនទាន់សល់អ្វីនិងខ្លួនប៉ុន្ដែ សប្បាយចិត្តមួយដែលនៅសល់ជីវិតមួយដែលមិនចេះច្រណែនឈ្នានីសអ្នកដទៃ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000194', '0168', '01', 'ស្ងប់ស្ងាត់មិនមានន័យថាមិនកើតអីនោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000195', '0168', '01', 'គ្រប់យ៉ាងគឺអាចទៅរួចលើកលែងតែយើងមិនព្រមធ្វើតែប៉ុណ្ណោះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000196', '0168', '01', 'ពាក្យថា ស្នេហា តែពីមាត់អាចធ្វើឲ្យមនុស្សសើចហើយក៏អាចធ្វើឲ្យយំបានដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000197', '0168', '01', 'កុំខ្សែលើមនុស្សដែលខំទុកចិត្តអ្នក កុំងាយជឿជាក់ដោយមិនបានគិតពិចារណាឲ្យបានច្បាស់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000198', '0168', '01', 'ទ្រព្យដ៏ធំបំផុតក្នុងជីវិតមិនមែនជាលុយឡាននោះទេ ទ្រព្យដ៏ធំបំផុតគឺជា សុខភាពទាំងផ្លូវកាយនិងផ្លូវចិត្ត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000199', '0168', '01', 'ពាក្យយ៉ាងខ្លីធ្វើឲ្យជីវិតប្លាស់ប្ដូរ មិនចាប់ផ្ដើមមិនជោគជ័យ ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90002', '0168', '01', 'កុំដាក់សម្ពាធឲខ្លួនឯងខ្លាំងពេកត្រូវចេះបង្កើតក្ដីសុខឲខ្លួនឯងខ្លះផង  3/រៀនបន្ទាបខ្លួនអោយទាប មិនខ្វះទេញាតិប្រសើរជាងតម្កើងខ្លួនខ្ពស់ជាងមេឃ គ្មានអ្នកក្បែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900020', '0168', '01', 'កុំងាកក្រោយស្ដាយអ្វីដែលបានបាត់បង ត្រូវបន្តទៅមុខឲ្យត្រង់ទើបឆាប់ដល់គោលដៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000200', '0168', '01', 'មនុស្សថ្លៃថ្នូរពិតប្រាកដ គេមិនចេះអួត មិនចេះសម្ដែង រឹតតែមិនចេះមើលងាយអ្នកផ្សេងដើម្បីលើកតម្កើនខ្លួនឯងឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000201', '0168', '01', 'មនុស្សពិតមិនខ្លាចគេនិយាយដើមសំខាន់គឺទង្វើរបស់យើងគឺស្មោះត្រង់និងត្រឹមត្រូវ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000202', '0168', '01', 'ថតរូបមិនស្អាតអ្នកនិងលុបចោលចុះរឿងកន្លងហួសម្ដេចមិនលុបចោលទៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000203', '0168', '01', 'គ្រប់ស្នាមញញឹមដែលអ្នកបានឃើញ តែលាក់ដោយទុក្ខដែលអ្នកមិនដឹង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000204', '0168', '01', 'ចូលជ្រើសរើសផ្លូវដើរដោយខ្លួនឯង ហើយត្រូវទទួលខុសត្រូវគ្រប់យ៉ាងដែលអ្នកបានជ្រើសរើស', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000205', '0168', '01', 'កូនអើយ!ពេលដែលយើងគ្មានទ្រព្យដូចគេអ្វីដែលយើងត្រូវធ្វើអ្វីដែលជាក្ដីស្រម៉ៃរបស់ខ្លួនចេញពីដៃទទេទៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000206', '0168', '01', 'បើចេះដាក់ខ្លួនរៀនពីគេមិនយូរទេអ្នកនិងរីកចម្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000207', '0168', '01', 'រឿងខ្លះកាន់តែគិតកាន់តែធ្វើអោយយើងស្មុកស្មាញ កាន់តែធ្វើឲ្យយើងបាក់ទឹកចិត្តកាន់តែខ្លាំង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000208', '0168', '01', 'ចង់បានសន្តិភាពផ្លូវចិត្ត ត្រូវរៀនទទួលស្គាល់ការពិត ហើយគិតវិជ្ជមានឲ្យបានច្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000209', '0168', '01', 'បើដួលត្រូវប្រញាប់ងើបទើបជីវិតឆាប់ទៅដល់គោលដៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900021', '0168', '01', 'កុំស្ដាប់តែម្ខាងបើចង់អោយរឿងគ្រប់យ៉ាង ជារឿងទាំងអស់ស្មើភាព', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000210', '0168', '01', 'ត្រូចេះស្គាប់ស្គាល់នៅអ្វីដែលខ្លួនមានទើបគ្មានក្ដីសៅហ្មងក្នុងជីវិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000211', '0168', '01', 'អ្នកនឹងមានក្ដីសុខនៅពេលដែលអ្នកចេះត្រេកអរនៅអ្វីដែលជារបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000212', '0168', '01', 'ខ្ញុំគ្រាន់តែសង្ឃឹមថាទង្វើល្អដែលខ្ញុំធ្លាប់មានកន្លងមកនឹងធ្វើអោយអ្នកចងចាំនិងនឹកឃើញនៅពេលដែលលែងមានខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000213', '0168', '01', 'ម៉ែជាមនុស្សតែម្នាក់គត់ដែលហ៊ានលះបង់គ្រប់យ៉ាងដើម្បីកូន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000214', '0168', '01', 'មានទ្រឹស្ដីល្អតែគ្មានការអនុវត្តក៏គ្មានផលដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000215', '0168', '01', 'ឲ្យតែមានឳកាសយើងនៅតែអាចអភិវឌ្ឍខ្លួនបាន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000216', '0168', '01', 'ធ្វើជាមនុស្សរស់នៅត្រូវចេះទទួលការពិតទើបជីវិតមិនសូវកើតទុក្ខ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000217', '0168', '01', 'មនុស្សល្ងង់ជឿមនុស្សលើសម្ដី មនុស្សឆ្លាតវៃ ជឿមនុស្សមើលលើទង្វើ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000218', '0168', '01', 'មនុស្សខ្ពង់ខ្ពស់ថ្លៃថ្នូរគ្មានថ្ងៃប្ដូអត្តចរិតទៅតាមទឹកលុយនោះឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000219', '0168', '01', 'ចិត្តល្អគំនិតល្អទើបជាភាពស្រស់ស្អាតពិតប្រាកដ មិនមែនស្រស់ស្អាតតែរូបរាងនោះទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900022', '0168', '01', 'នៅពីក្រោយស្នាមញញឹមមានរឿងជាច្រើនដែលអ្នកមិនបានដឹង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000220', '0168', '01', 'ហត់កាយអាចសម្រាកបានតែបើហត់ចិតពិបាកឈប់ខ្លាំងណាស់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000221', '0168', '01', 'មនុស្សខ្លះល្អនៅតែចំពោះមុខយើងតែប៉ុណ្ណោះតែក្រោយខ្នងវិញគួរឲ្យខ្លាច', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000222', '0168', '01', 'ធ្វើដោយខ្លួនឯងទើបជីវិតមានន័យ កុំរស់ផ្គាប់ចិត្តអ្នកដទៃជីវិតគ្មានក្ដីសុខទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000223', '0168', '01', 'ភាពអត់ធ្មត់ពិតជាលំបាកតែវានិងធ្វើឲ្យអ្នកទទួលបានផលល្អត្រឡប់មកវិញ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000224', '0168', '01', 'បើឪពុកក្រត្រូវធ្វើឲ្យគាត់មានមោទណភាពដែលមានអ្នកជាកូន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000225', '0168', '01', 'នៅក្បែមនុស្សល្អទើបជីវិតមានក្ដីសុខ នៅក្បែមនុស្សកើតទុកជីវិតគ្មានក្ដីសុខឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000226', '0168', '01', 'ពឹងគេពិបាកណាស់ជួយខ្លួនឯងសិនទៅមុនរកគេមកជួយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000227', '0168', '01', 'ពេលដែលពិបាកខ្លាំងបានត្រឹមតែប្រាប់ខ្លួនឯងថារឹងមាំនិងអត់ធ្មត់បន្តិចទៅបន្ដិតទៀតគ្រប់យ៉ាងនឹងល្អហើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000228', '0168', '01', 'ឲ្យចំណីខួរក្បាល់ដោយគិតវិជ្ជមានវានិងទាញរឿងល្អចូលក្នុងជីវិតអ្នក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000229', '0168', '01', 'ការងារអ្វីក៏មានតម្លៃដែរអោយតែចេញពីញើញឈាមរបស់អ្នក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900023', '0168', '01', 'ទង្វើល្អគេមិនដែលចាំ ខុសបន្ដិគេចាំមួយជីវិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000230', '0168', '01', 'ម៉ែតែប្រាប់ថាគ្រប់ពេលដែលកូនជួបបញ្ហា វាជាមេរៀននិងបពិសោធជីវិតមិនមែនជាឧបសគ្គទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000231', '0168', '01', 'ចុងក្រោយមានតែខ្លួនឯងប៉ណ្ណោះដែលតែងតែមើលថែនិងកំដរខ្លួនឯងគ្រប់ពេល', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000232', '0168', '01', 'មិត្តល្អជាមនុស្សដែលហ៊ាននិយាយពីចំណុចអាក្រក់ចំពោះមុខយើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000233', '0168', '01', 'ចាកចេញពីកន្លែងដែលមិនរីកចម្រើនស្មើនឹងជួយខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000234', '0168', '01', 'ស្នាមញញឹមរបស់ម៉ែគឺជាកម្លាំងចិត្តដ៏ធំធេងបំផុតសម្រាប់ជីវិតរបស់កូន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000235', '0168', '01', 'រស់នៅម្នាក់ឯងវាពិតជាអផ្សុក និងឯកា តែបើយើងចេះរស់នៅជាមួយខ្លួនឯងជីវិតយើងមិនឯកាឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000236', '0168', '01', 'ថ្ងៃនេះអ្នកធ្វើបានល្អហើយប្រឹងបន្ដទៀតទៅ ថ្ងៃស្អែកនឹងប្រសើរជាងនេះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000237', '0168', '01', 'ធ្វើការដែលអ្នកស្រឡាញ់អ្នននិងលោតចេញពីគ្រែរាល់ព្រឹងដោយក្ដីរីរាយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000238', '0168', '01', 'រៀនហោះហើរខ្លះ រៀនឲ្យជីវិតប្រថុយខ្លះកុំដូចកង្កែបក្នុងអណ្ដូងពេក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000239', '0168', '01', 'ចង់រកសុីអ្នកត្រូវតែហ៊ានប្រថុយ  ហ៊ានប្រថុយបើឈ្នះអ្នកនឹងសប្បាយចិត្ត បើប្រថុយចាញ់អ្នកនឹងឆ្លាតជាងមុន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900024', '0168', '01', 'ពាក្យថាចាយទៅលុយ ស្លាប់ទៅគ្មានបានចាយទេ ឥឡូវចាយអស់ហើយនៅឡើយមិនទាន់ស្លាប់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000240', '0168', '01', 'ពេលវេលាដែលឥតប្រយោជន៍បំផុតជាពេលវេលាដែលអ្នកដែកច្រណែនអ្នកដទៃ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000241', '0168', '01', 'ទ្រាំៗទៅរាល់បញ្ហាទាំងអស់នឹងបង្រៀនឲ្យយើងចេះរឹងមាំ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000242', '0168', '01', 'កុំហុសដ៏ធំបំផុតរបស់ខ្ញុំ គិតថាអ្នកដទៃស្មោះត្រងនឹងខ្ញុំដូចដែលខ្ញុំស្មោះត្រង់នឹងគេដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000243', '0168', '01', 'កុំឈឺចាប់ជាមួយអ្វីដែលអ្នកគ្មាន រហូតភ្លេចភាពរីករាយជាមួយអ្វីដែលអ្នកកំពុងមាន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000244', '0168', '01', 'ពេលវេលាអ្នកកែប្រែអ្វីគ្រប់យ៉ាងបានសូម្បីតែចិតមនុស្ស ដែលភ្លាប់គិតថាល្អក៏ផ្ទុយស្រឡះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000245', '0168', '01', 'គ្មានអ្វីដែលថាយើងធ្វើមិនបាននោះទេ លើកលែងតែយើងមិនព្រមធ្វើ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000246', '0168', '01', 'រៀនបោះចោលរឿងអត់បានការខ្លះទៅទើបអ្នកមិនកម្លាំងដើរទៅមុខបន្ដ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000247', '0168', '01', 'ជីវិតអ្នកនឹងកាត់តែលំបាកបើអ្នករតគេចចេញពីបញ្ហា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000248', '0168', '01', 'គ្មានអ្វីក្រអូបជាងកេរ្ដិ៍ឈ្មោះ គ្មានអ្វីដែលពិរោះជាងសម្ដី  ហើយក៏គ្មានអ្វីដែលមានតម្លៃជាអត្តចិរិតដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000249', '0168', '01', 'ជោគជ័យខ្លះវាតូចតាចសម្រាប់អ្នកដទៃតែវាមានន័យសម្រាប់ខ្លួនយើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900025', '0168', '01', 'ប្រើពេលឲ្យមានតម្លៃស្លាប់ទៅ ក៏បានបន្សល់កេរ្ដិ៍ឈ្មោះទុកដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000250', '0168', '01', 'ប៉ាគឺជាបុរសតែម្នាក់គត់ដែលអស្ចារ្យជាងគេក្នុងលោក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000251', '0168', '01', 'ធ្វើជាមនុស្សកុំល្អតែសម្ដី សម្ដីក៏ល្អទង្វើក៏ល្អ ទើបជាមនុស្សល្អពិត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000252', '0168', '01', 'សប្បាយភ្លេចខ្លួនវានិងនាំឲ្យអ្នកជួបនៅគ្រោះថ្នាក់ដែលអ្នកនឹកស្មានមិនដល់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000253', '0168', '01', 'មនុស្សល្អពិតមិនខ្លាចគេនិយាយដើមសំខាន់ លើទង្វើរបស់យើងគឺស្មោះត្រង់នឹងល្អត្រឹមត្រូវ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000254', '0168', '01', 'រឿងខ្លះមិនត្រូវការទាមទារឲ្យអ្នកឆ្លាតនោះទេ ប៉ុន្ដែវាត្រូវការភាពក្លាហ៊ាន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000255', '0168', '01', 'ថ្ងៃលិចគង់តែរះ បើថ្ងៃនេះបរាជ័យ គង់តែមានឳកាសនៅថ្ងៃស្អែកទៀត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000256', '0168', '01', 'ជីវិតរស់នៅកុំជាប់ទុក្ខសោក មេឃងងឹតគង់តែភ្លឺជីវិតយើងក៏មិនលំបាករហូតដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000257', '0168', '01', 'គ្រែគឺជាគុករបស់មនុស្សខ្ជិល', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000258', '0168', '01', 'សៀវភៅល្អសម្រាប់អ្នកចង់អានតែ វាថ្នាំងងុយដេកសម្រាប់អ្នកខ្ជិល', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000259', '0168', '01', 'មានតែការរាប់អានមិនគិតពីប្រយោជទេទើបអាចរក្សាមិត្តភាពបានយូរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900026', '0168', '01', 'ថ្ងៃរះហើយក្រោកឡើង កុំទុកខ្លួនឲ្យលិចទៀត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000260', '0168', '01', 'ការដែលយើងគិតអ្នកដែលល្អ វានឹងនាំរឿងល្អៗចូលក្នុងជាវិតយើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000261', '0168', '01', 'កុំដើរចង្អុលអ្នកដទៃថាអាក្រក់ទាំងដែលខ្លួនឯងមិនទាន់ល្អគ្រប់គ្រាន់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000262', '0168', '01', 'មនុស្សខ្ញុំតែងតែក្រែងចិត្តគេតែគេមិនដែលក្រែងចិត្តខ្ញុំឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000263', '0168', '01', 'ជីវិតនឹងត្រូវចេះប្រឹងដោយខ្លួនឯង បើដេកចាំសំណាងមិនដឹងពេលណាបានល្អទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000264', '0168', '01', 'រៀនមើលពីគំនិតអ្នកមានតែកុំចាយលុយឲ្យដូចអ្នកមាន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000265', '0168', '01', 'ស្នាមញញឹមពេលខ្លះវាគ្រាន់តែជាស្នាមញញឹមដើម្បី លុបបំបាត់ទុកសោកប៉ុណ្ណោះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000266', '0168', '01', 'បើអាចទាញពេលឲ្យវិលត្រឡប់វិញបាន ខ្ញុំនឹងទាញយកសេចក្ដីសុខដែលខ្ញុំធ្លាប់មានត្រឡប់មកវិញ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000267', '0168', '01', 'រស់នៅជាខ្លួនឯងប្រសើរជាងរស់នៅ ដើម្បីតែទំនាក់ទំនងក្លែងក្លាយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-9000268', '0168', '01', 'ជីវិតខ្ញុំបើប្រាក់ខែភ្លាមសងគេភ្លេត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900027', '0168', '01', 'សេដ្ឋីវាល់លាន គេប្រឹងមិនឈប់ឯងហូបស្ទើមិនគ្រប់កុំលួចខ្ជិលអី', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900028', '0168', '01', 'គេពួកែជាងយើងដោយសារគេបានចាប់ផ្ដើមុនយើង ដូច្នេះកុំគិតថាខ្លួនអន់អោយសោះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900029', '0168', '01', 'ភាពស្មោះត្រង់ត្រឹមតែបបូរមាត់មិនគ្រប់គ្រាន់ទេ ហើយក៏មិនអាចខ្លាយជាមនុស្សស្មោះត្រង់បានឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90003', '0168', '01', 'មនុស្សដែលមិនខ្លាចឈឺចាប់ក្នុងការផ្លាស់ប្ដូរគឺជាមនុស្សដែលជោគជ័យខ្លាំងបំផុត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900030', '0168', '01', 'ពេលអ្នកជួបស្ថានភាពលំបាក មានតែអ្នកផ្ទះទេដែលជាទីព្រឹក្សាល្អបំផុត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900031', '0168', '01', 'មួយរយៈនេះអារម្មណ៍មិនសូវល្អទេព្រោះគ្មានចំណូលមានតែចំណាយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900032', '0168', '01', 'ធ្វើល្អមិនចាំបាច់អោយអ្នកណាមើល ព្រោះមនុស្សខ្លះគេមើលតែពេលយើងធ្វើមិនល្អ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900033', '0168', '01', 'បញ្ហាយប់នេះទុកដោះស្រាយថ្ងៃស្អែក ឆាប់ចូលដំណេកកុំឲ្យខូចសុខភាព', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900034', '0168', '01', 'គេមើលងាយក្ដីស្រមៃអ្នក កុំអន់ចិត្តត្រូវញញឹមដើរចេញហើយខំប្រឹងអោយខ្លាំងជាងមុន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900035', '0168', '01', 'ខំប្រឹងស្ងាត់ៗតែមានអ្វីគ្រប់យ៉ាង ប្រសើរជាងពូកែអូតអាងតែប្រហោងក្នុង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900036', '0168', '01', 'កុំពូកែតែមើលកុំហុសអ្នកដទៃ ប៉ុន្ដែមិនដែលឆ្លុះបញ្ជាំងខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900037', '0168', '01', 'ពេលអ្នកធ្វើអ្វីមួយហើយទទួលទទួលបរាជ័យ អ្នកគួរតែអប់អរខ្លួនឯងព្រោះមនុស្សជាច្រើនមិនហានសូម្បីតែសាក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900038', '0168', '01', 'កុំខ្មាសអៀនក្នុងការចាប់ផ្ដើមរបរតូចតាច តែគួរឲ្យខ្មាសគេដែលមិនហានចាប់ផ្ដើមអ្វីសោះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900039', '0168', '01', 'កុំបោះបង់ចោលគោលដៅទោះនូវសល់ក្ដីសង្ឃឹម១% ក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90004', '0168', '01', 'ខ្ញុំពិបាកឡើងធ្លាប់អស់ទៅហើយ ខ្ញុំចេះទទួលយកភាពរីករាយក្នុងពេលលំបាក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900040', '0168', '01', ' ទោះបីមានរឿងអ្វីក៏ដោយអ្នកត្រូវតស៊ូធ្វើដំណើរទៅមុខជានិច្ច', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900041', '0168', '01', 'គិតវិជ្ជមានឲ្យបានច្រើនថែសុខភាពអោយបានល្អទើបគ្មានសម្ពាធផ្លូវចិត្ត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900042', '0168', '01', ' ឆាកជីវិតមនុស្សដូចដើមឈើអញ្ជឹងពេលលូតលាស់គ្មានសំឡេង ពេលរលំវិញលាន់ដូចរន្ទះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900043', '0168', '01', 'គេដេកយើងដើរ គេដើរយើងរត់ ប្រឹងបន្ដដំណើរទៅមុខអ្នកនិងទៅដល់គោលដៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900044', '0168', '01', 'ស្គាល់មនុស្សច្រើនហើយតែស្គាល់ច្បាស់គ្មានម្នាក់សោះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900045', '0168', '01', 'រស់មិនស្រួលមិនអីទេ កុំអោយតែស្លាប់ក៏ពិបាកទើបវេទនា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900046', '0168', '01', 'កុំបង្កើតជម្លោះព្រោះតែចង់ល្បី កុំជាន់អ្នកដទៃដើម្បីខ្លួនឯងល្អ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900047', '0168', '01', 'រឿងអស្ចារ្យត្រូវការពេលវេលាកុំចង់សម្រេចអ្វីមួយត្រឹមតែមួយថ្ងៃឬមួយយប់ ត្រូវចេះអត់ធ្មត់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900048', '0168', '01', 'លុយពិតជាសំខាន់តែកុំដើម្បីលុយ ធ្វើអោយបាត់បង់មិត្តភាពដ៏ល្អព្រោះតែខ្ចីលុយមិនសង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900049', '0168', '01', 'ហាមបាក់ទឹកចិត្តទោះបីជីវិតធ្លាក់ដល់កម្រិតណាក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90005', '0168', '01', 'វាស់អ្វីបានតែវាស់សន្ដានចិត្តមនុស្សគឺមិនអាចទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900050', '0168', '01', 'ជីវិតប្រៀបដូចនឹងការធ្វើដំណើរបើអ្នកមិនហ៊ានជ្រើសរើសផ្លូវដើរអ្នកនិងនូវកន្លែងដដែល', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900051', '0168', '01', 'កុំខំដោយសារលុយរហូតធ្លាក់ខ្លួនឈឺធ្ងន់ លុយមិនអាចទិញសុខភាពយើងមកវិញបានទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900052', '0168', '01', 'សម្ដីលើកទឹកចិត្តមួយម៉ាត់ក្នុងគ្រាលំបាក មានន័យជាងពាក្យសរសើររាប់រយម៉ាត់ពេលជោគជ័យ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900053', '0168', '01', 'ដង្កូវក៏អាចក្លាយជាមេអំបៅ កុំមើលងាយមនុស្សតែសំបកក្រៅប្រយ័ត្នស្ដាយក្រោយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900054', '0168', '01', 'កុំខ្ជះខ្ជាយពេលវេលារហូតភ្លេចគិតពីវ័យរបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900055', '0168', '01', 'សាកល្បងមិនប្រាកដថាត្រូវទេ តែអ្វីដែលខុសធ្ងន់គឺមិនហាន់សាកល្បង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900056', '0168', '01', 'សន្យាណាបើថ្ងៃណាមួយអ្នកក្លាយជាអ្នកមានអ្នកត្រូវធ្វើជាអ្នកមានចិត្តសប្បុរសចេះជួយជនក្រីក្រ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900057', '0168', '01', 'កើតជាមនុស្សកុំខ្សែលើគេពេក កុំលោភលន់ពេកប្រយ័ត្នអត់ញាតិរាប់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900058', '0168', '01', 'ការងារអ្វីក៏ថ្លៃថ្នូរដែរអោយតែប្រឹងដោយកម្លាំងខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900059', '0168', '01', 'ចិត្តទូលាយ តែកុំចិត្តទុន ចិត្តទូលាយគឺជាបុណ្យ ចិត្តទុនគឺជាគ្រោះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90006', '0168', '01', 'រស់ពឹងខ្លួនឯងទើបជីវិតមានន័យ រស់ពឹងអ្នកដទៃនាំអោយបាត់តម្លៃខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900060', '0168', '01', 'រឿងចាំបាច់បំផុតដែលអ្នកត្រូវមាននោះគឺភាពអត់ធ្មត់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900061', '0168', '01', 'យប់ហើយដេកទៅស្អែកចាំគេតទៀត ឈប់សិនទៅដើម្បីកម្លាំងសម្រាប់ថ្ងៃស្អែក', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900062', '0168', '01', 'គេក្បត់ខ្ញុំជារឿងរបស់គេ ខ្ញុំមិនក្បត់គេគឺជាគុណធម៌របស់ខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900063', '0168', '01', 'មនុស្សអស្ចារ្យគឺជាមនុស្សដែលជួបបញ្ហាហើយ តែនៅអាចញញឹមបានដូចធម្មតា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900064', '0168', '01', 'ទោះផ្លូវទៅមុខលំបាកយ៉ាងណា ខ្ញុំសន្យានិងខ្លួនឯងថានឹងត្រូវដើរឲ្យដល់គោលដៅរបស់ខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900065', '0168', '01', 'ទង្វើល្អប្រសើរជាងសម្ដីល្អ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900066', '0168', '01', 'ទឹកស្ងាប់មិនប្រាកដថាគ្មានត្រី អ្នកមិនចេះនិយាយស្ដីមិនប្រាកដថាល្ងង់ដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900067', '0168', '01', 'ចង់បានអ្វីត្រូវប្រឹងកុំចាំព្រេងសំណាង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900068', '0168', '01', 'មានរឿងខ្លះខ្ជិលបកស្រាយទុកអោយឆ្ងល់', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900069', '0168', '01', 'កុំដាក់ខ្លួនដល់គេមើលងាយ កុំចិត្តទូលាយដល់ថ្នាក់គេបោកប្រាស', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90007', '0168', '01', 'ជីវិតពេលមានគ្រួសារមិនបាច់ហុឺដូចគេត្រឹមតែមានសុភមង្គលរាល់ថ្ងៃទៅបានហើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900070', '0168', '01', 'ត្រូវចេះសរសើរនិងអរគុណខ្លួនឯង ដែលអាចឆ្លងកាត់ការលំបាកតាំងពីតូចរហូតដល់ពេលនេះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900071', '0168', '01', 'កុំរវល់ដេកអោបក្រសោបទុក្ខពេកអីជីវិតរស់នៅមិនបាន១០០ឆ្នាំទេ អ្វីដែលគួរកើតវានឹងកើតគ្រប់យ៉ាងវាសុទ្ធតែមានហេតុផលរបស់វា', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900072', '0168', '01', 'ក្ដីស្រម៉ៃខ្ញុំគឺជាអ្នករកសុី ទោះជួបការលំបាកច្រើនយ៉ាងណាក៏មិនចុះចាញ់ដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900073', '0168', '01', 'អ្នករកសុី សាមញ្ញណាស់សុខចិត្តប្រើរស់ចាស់ទុកលុយធ្វើដើម', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900074', '0168', '01', 'ដៃដែលហុចមកជួយខ្ញុំពេលជួបគ្រាលំបាក មួយជីវិតនេះខ្ញុំមិនអាចបំភ្លេចបានឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900075', '0168', '01', 'រៀនមិនពូកែមិនមែនសុទ្ធតែល្ងង់ អ្នកមិនពូកែក្នុងសាលាមិនប្រាកដថាអ្នកបរាជ័យក្នុងជីវិតឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900076', '0168', '01', 'គ្មានពេលណាវេទនាជាងពេលដែលចេញរកសុីដំបូងនោះឡើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900077', '0168', '01', 'ជឿអត់ថ្ងៃណាមួយខ្ញុំនិងចេញរកសុី អោយទាល់តែបានទោះខ្ញុំមានបពិសោធន៍តិចតួចក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900078', '0168', '01', 'កុំខ្វល់សម្ដីមនុស្សអវិជ្ជមាន បើអ្នកគិតល្អនិយាយល្អធ្វើល្អ អ្នកជាមនុស្សល្អហើយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900079', '0168', '01', 'ដេកទៅយប់ហើយស្អែកមានការងារត្រូវដោះស្រាយទៀត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90008', '0168', '01', 'យើងខំរកសីុលំបាកស្ទើក្ស័យពេលជោគជ័យគេថាមកពីសំណាង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900080', '0168', '01', 'ពេលវេលាមិនអាចបកស្រាយទេ កុំទុកខ្លួនឲ្យទំនេរហូតអស់ពេលបំពេញក្ដីស្រម៉ៃ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900081', '0168', '01', 'គ្មានអ្វីបានមកដោយស្រួលៗទេ កុំរំពឹងលើវាសនា ត្រូវរំពឹងលើការប្រឹងប្រែងរបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900082', '0168', '01', 'មុនធ្វើអ្វី ត្រូវគិតបើធ្វើដោយមិនគិតប្រយ័ត្នមានវប្បដិសារិ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900083', '0168', '01', 'គេប្រឹងណាស់ទើបមាន មិនមែនអង្គុយស្ងៀមៗ លុយធ្លាក់ពីលើមេឃទេ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900084', '0168', '01', 'ឳពុកខ្ញុំបង្រៀនខ្ញុំថាបើខ្លួនពូកែកុំមើលងាយអ្នកដទៃ បើកូនបរាជ័យកុំបាក់ទឹកចត្ត', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900085', '0168', '01', 'ភាពក្រែចិត្តរបស់អ្នកដទៃ គឺសេចក្ដីថ្លៃថ្នូវររបស់យើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900086', '0168', '01', 'ធ្វើជាមនុស្សកុំមានអំនួត កាត់តែអួត គេកាន់ជ្រេញ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900087', '0168', '01', 'មិនមែនខ្ញុំមិនដឹងនោះទេ ប៉ុន្ដែមានពេលខ្លះមនុស្សឆ្លាតក៏ត្រូវធ្វើល្ងង់ដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900088', '0168', '01', 'យើងគ្មានទ្រព្យធន សម្ដីក៏គ្មានន័យ តែបើយើងមានលុយពេញដៃសម្ដីប្រៃជាអំបិល', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900089', '0168', '01', 'កើតមកជាមនុស្សត្រូវតែរឹងមាំ ទោះត្រូវធ្លាក់ដល់កម្រិតណាក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90009', '0168', '01', 'ចង់រស់បានសុខកុំបំពានអ្នកដទៃចង់ឲ្យជីវិតមានន័យត្រូវជួយដល់អ្នកដទៃឲ្យបានច្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900090', '0168', '01', 'គិតឲ្យជ្រៅធ្វើឲ្យលះទើបសម្រេចគោលដៅ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900091', '0168', '01', 'ការតស៊ូគឺជាស្ពានចម្លងអ្នកទៅរកភាពជោគជ័យ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900092', '0168', '01', 'កុំទាន់ហឺហា ដរាបណាប្រាក់ខែនៅតិច ចំណូលនៅស្ទើ ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900093', '0168', '01', 'តាមរកក្ដីស្រម៉ៃអ្នកឲ្យឃើញទោះតាមដល់ជើងមេឃក៏ត្រូវរកឲ្យឃើញដែរ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900094', '0168', '01', 'រាល់ថ្ងៃខំប្រឹងណាស់សង្ឃឹមថាថ្ងៃក្រោយនឹងមានផ្ទះតូចមួយជាកាដូសម្រាប់ខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900095', '0168', '01', 'មិនពង្រឹងសមត្ថភាពឲ្យកាន់តែពូកែ ស្មើនិងបំផ្លាញ់ឧកាសខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900096', '0168', '01', 'ការផ្លាស់ប្ដូរមិនមែនស្រួលទេតែវានិងធ្វើឲ្យយើងរីកចម្រើន', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900097', '0168', '01', ' កុំចាញ់ជាមួយបញ្ហា ត្រូវសន្យានឹងខ្លួនឯងថាយ៉ាងណាក៏មិនបោះបង់ព្រោះវាជាក្ដីស្រម៉ៃរបស់យើង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900098', '0168', '01', 'ផ្លូវជីវិតនៅវែងឆ្ងាយណាស់ កុំគិតតែរឿងសប្បាយរហូតភ្លេចគិតពីអនាគតខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-900099', '0168', '01', 'កុំថ្មមខ្លួនពេកទាន់វ័យនៅក្មេងប្រឹងរកលុយណាស់ ក្រែង៥ឆ្នាំក្រោយជីវិតប្រសើរជាងនេះ', 'IT.SYTEM', '2021-08-14 04:52:35'),
('0168-90021', '0168', '01', 'កុំស្ដាប់តែម្ខាងបើចង់អោយរឿងគ្រប់យ៉ាង ជារឿងទាំងអស់ស្មើភាព', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90022', '0168', '01', 'នៅពីក្រោយស្នាមញញឹមមានរឿងជាច្រើនដែលអ្នកមិនបានដឹង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90023', '0168', '01', 'ទង្វើល្អគេមិនដែលចាំ ខុសបន្ដិគេចាំមួយជីវិត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90024', '0168', '01', 'ពាក្យថាចាយទៅលុយ ស្លាប់ទៅគ្មានបានចាយទេ ឥឡូវចាយអស់ហើយនៅឡើយមិនទាន់ស្លាប់', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90025', '0168', '01', 'ប្រើពេលឲ្យមានតម្លៃស្លាប់ទៅ ក៏បានបន្សល់កេរ្ដិ៍ឈ្មោះទុកដែរ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90026', '0168', '01', 'ថ្ងៃរះហើយក្រោកឡើង កុំទុកខ្លួនឲ្យលិចទៀត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90027', '0168', '01', 'សេដ្ឋីវាល់លាន គេប្រឹងមិនឈប់ឯងហូបស្ទើមិនគ្រប់កុំលួចខ្ជិលអី', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90028', '0168', '01', 'គេពួកែជាងយើងដោយសារគេបានចាប់ផ្ដើមុនយើង ដូច្នេះកុំគិតថាខ្លួនអន់អោយសោះ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90029', '0168', '01', 'ភាពស្មោះត្រង់ត្រឹមតែបបូរមាត់មិនគ្រប់គ្រាន់ទេ ហើយក៏មិនអាចខ្លាយជាមនុស្សស្មោះត្រង់បានឡើយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9003', '0168', '01', 'មនុស្សដែលមិនខ្លាចឈឺចាប់ក្នុងការផ្លាស់ប្ដូរគឺជាមនុស្សដែលជោគជ័យខ្លាំងបំផុត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90030', '0168', '01', 'ពេលអ្នកជួបស្ថានភាពលំបាក មានតែអ្នកផ្ទះទេដែលជាទីព្រឹក្សាល្អបំផុត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90031', '0168', '01', 'មួយរយៈនេះអារម្មណ៍មិនសូវល្អទេព្រោះគ្មានចំណូលមានតែចំណាយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90032', '0168', '01', 'ធ្វើល្អមិនចាំបាច់អោយអ្នកណាមើល ព្រោះមនុស្សខ្លះគេមើលតែពេលយើងធ្វើមិនល្អ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90033', '0168', '01', 'បញ្ហាយប់នេះទុកដោះស្រាយថ្ងៃស្អែក ឆាប់ចូលដំណេកកុំឲ្យខូចសុខភាព', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90034', '0168', '01', 'គេមើលងាយក្ដីស្រមៃអ្នក កុំអន់ចិត្តត្រូវញញឹមដើរចេញហើយខំប្រឹងអោយខ្លាំងជាងមុន', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90035', '0168', '01', 'ខំប្រឹងស្ងាត់ៗតែមានអ្វីគ្រប់យ៉ាង ប្រសើរជាងពូកែអូតអាងតែប្រហោងក្នុង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90036', '0168', '01', 'កុំពូកែតែមើលកុំហុសអ្នកដទៃ ប៉ុន្ដែមិនដែលឆ្លុះបញ្ជាំងខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90037', '0168', '01', 'ពេលអ្នកធ្វើអ្វីមួយហើយទទួលទទួលបរាជ័យ អ្នកគួរតែអប់អរខ្លួនឯងព្រោះមនុស្សជាច្រើនមិនហានសូម្បីតែសាក', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90038', '0168', '01', 'កុំខ្មាសអៀនក្នុងការចាប់ផ្ដើមរបរតូចតាច តែគួរឲ្យខ្មាសគេដែលមិនហានចាប់ផ្ដើមអ្វីសោះ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90039', '0168', '01', 'កុំបោះបង់ចោលគោលដៅទោះនូវសល់ក្ដីសង្ឃឹម១% ក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9004', '0168', '01', 'ខ្ញុំពិបាកឡើងធ្លាប់អស់ទៅហើយ ខ្ញុំចេះទទួលយកភាពរីករាយក្នុងពេលលំបាក', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90040', '0168', '01', ' ទោះបីមានរឿងអ្វីក៏ដោយអ្នកត្រូវតស៊ូធ្វើដំណើរទៅមុខជានិច្ច', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90041', '0168', '01', 'គិតវិជ្ជមានឲ្យបានច្រើនថែសុខភាពអោយបានល្អទើបគ្មានសម្ពាធផ្លូវចិត្ត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90042', '0168', '01', ' ឆាកជីវិតមនុស្សដូចដើមឈើអញ្ជឹងពេលលូតលាស់គ្មានសំឡេង ពេលរលំវិញលាន់ដូចរន្ទះ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90043', '0168', '01', 'គេដេកយើងដើរ គេដើរយើងរត់ ប្រឹងបន្ដដំណើរទៅមុខអ្នកនិងទៅដល់គោលដៅ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90044', '0168', '01', 'ស្គាល់មនុស្សច្រើនហើយតែស្គាល់ច្បាស់គ្មានម្នាក់សោះ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90045', '0168', '01', 'រស់មិនស្រួលមិនអីទេ កុំអោយតែស្លាប់ក៏ពិបាកទើបវេទនា', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90046', '0168', '01', 'កុំបង្កើតជម្លោះព្រោះតែចង់ល្បី កុំជាន់អ្នកដទៃដើម្បីខ្លួនឯងល្អ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90047', '0168', '01', 'រឿងអស្ចារ្យត្រូវការពេលវេលាកុំចង់សម្រេចអ្វីមួយត្រឹមតែមួយថ្ងៃឬមួយយប់ ត្រូវចេះអត់ធ្មត់', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90048', '0168', '01', 'លុយពិតជាសំខាន់តែកុំដើម្បីលុយ ធ្វើអោយបាត់បង់មិត្តភាពដ៏ល្អព្រោះតែខ្ចីលុយមិនសង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90049', '0168', '01', 'ហាមបាក់ទឹកចិត្តទោះបីជីវិតធ្លាក់ដល់កម្រិតណាក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9005', '0168', '01', 'វាស់អ្វីបានតែវាស់សន្ដានចិត្តមនុស្សគឺមិនអាចទេ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90050', '0168', '01', 'ជីវិតប្រៀបដូចនឹងការធ្វើដំណើរបើអ្នកមិនហ៊ានជ្រើសរើសផ្លូវដើរអ្នកនិងនូវកន្លែងដដែល', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90051', '0168', '01', 'កុំខំដោយសារលុយរហូតធ្លាក់ខ្លួនឈឺធ្ងន់ លុយមិនអាចទិញសុខភាពយើងមកវិញបានទេ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90052', '0168', '01', 'សម្ដីលើកទឹកចិត្តមួយម៉ាត់ក្នុងគ្រាលំបាក មានន័យជាងពាក្យសរសើររាប់រយម៉ាត់ពេលជោគជ័យ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90053', '0168', '01', 'ដង្កូវក៏អាចក្លាយជាមេអំបៅ កុំមើលងាយមនុស្សតែសំបកក្រៅប្រយ័ត្នស្ដាយក្រោយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90054', '0168', '01', 'កុំខ្ជះខ្ជាយពេលវេលារហូតភ្លេចគិតពីវ័យរបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90055', '0168', '01', 'សាកល្បងមិនប្រាកដថាត្រូវទេ តែអ្វីដែលខុសធ្ងន់គឺមិនហាន់សាកល្បង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90056', '0168', '01', 'សន្យាណាបើថ្ងៃណាមួយអ្នកក្លាយជាអ្នកមានអ្នកត្រូវធ្វើជាអ្នកមានចិត្តសប្បុរសចេះជួយជនក្រីក្រ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90057', '0168', '01', 'កើតជាមនុស្សកុំខ្សែលើគេពេក កុំលោភលន់ពេកប្រយ័ត្នអត់ញាតិរាប់', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90058', '0168', '01', 'ការងារអ្វីក៏ថ្លៃថ្នូរដែរអោយតែប្រឹងដោយកម្លាំងខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90059', '0168', '01', 'ចិត្តទូលាយ តែកុំចិត្តទុន ចិត្តទូលាយគឺជាបុណ្យ ចិត្តទុនគឺជាគ្រោះ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9006', '0168', '01', 'រស់ពឹងខ្លួនឯងទើបជីវិតមានន័យ រស់ពឹងអ្នកដទៃនាំអោយបាត់តម្លៃខ្លួន', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90060', '0168', '01', 'រឿងចាំបាច់បំផុតដែលអ្នកត្រូវមាននោះគឺភាពអត់ធ្មត់', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90061', '0168', '01', 'យប់ហើយដេកទៅស្អែកចាំគេតទៀត ឈប់សិនទៅដើម្បីកម្លាំងសម្រាប់ថ្ងៃស្អែក', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90062', '0168', '01', 'គេក្បត់ខ្ញុំជារឿងរបស់គេ ខ្ញុំមិនក្បត់គេគឺជាគុណធម៌របស់ខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90063', '0168', '01', 'មនុស្សអស្ចារ្យគឺជាមនុស្សដែលជួបបញ្ហាហើយ តែនៅអាចញញឹមបានដូចធម្មតា', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90064', '0168', '01', 'ទោះផ្លូវទៅមុខលំបាកយ៉ាងណា ខ្ញុំសន្យានិងខ្លួនឯងថានឹងត្រូវដើរឲ្យដល់គោលដៅរបស់ខ្ញុំ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90065', '0168', '01', 'ទង្វើល្អប្រសើរជាងសម្ដីល្អ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90066', '0168', '01', 'ទឹកស្ងាប់មិនប្រាកដថាគ្មានត្រី អ្នកមិនចេះនិយាយស្ដីមិនប្រាកដថាល្ងង់ដែរ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90067', '0168', '01', 'ចង់បានអ្វីត្រូវប្រឹងកុំចាំព្រេងសំណាង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90068', '0168', '01', 'មានរឿងខ្លះខ្ជិលបកស្រាយទុកអោយឆ្ងល់', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90069', '0168', '01', 'កុំដាក់ខ្លួនដល់គេមើលងាយ កុំចិត្តទូលាយដល់ថ្នាក់គេបោកប្រាស', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9007', '0168', '01', 'ជីវិតពេលមានគ្រួសារមិនបាច់ហុឺដូចគេត្រឹមតែមានសុភមង្គលរាល់ថ្ងៃទៅបានហើយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90070', '0168', '01', 'ត្រូវចេះសរសើរនិងអរគុណខ្លួនឯង ដែលអាចឆ្លងកាត់ការលំបាកតាំងពីតូចរហូតដល់ពេលនេះ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90071', '0168', '01', 'កុំរវល់ដេកអោបក្រសោបទុក្ខពេកអីជីវិតរស់នៅមិនបាន១០០ឆ្នាំទេ អ្វីដែលគួរកើតវានឹងកើតគ្រប់យ៉ាងវាសុទ្ធតែមានហេតុផលរបស់វា', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90072', '0168', '01', 'ក្ដីស្រម៉ៃខ្ញុំគឺជាអ្នករកសុី ទោះជួបការលំបាកច្រើនយ៉ាងណាក៏មិនចុះចាញ់ដែរ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90073', '0168', '01', 'អ្នករកសុី សាមញ្ញណាស់សុខចិត្តប្រើរស់ចាស់ទុកលុយធ្វើដើម', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90074', '0168', '01', 'ដៃដែលហុចមកជួយខ្ញុំពេលជួបគ្រាលំបាក មួយជីវិតនេះខ្ញុំមិនអាចបំភ្លេចបានឡើយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90075', '0168', '01', 'រៀនមិនពូកែមិនមែនសុទ្ធតែល្ងង់ អ្នកមិនពូកែក្នុងសាលាមិនប្រាកដថាអ្នកបរាជ័យក្នុងជីវិតឡើយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90076', '0168', '01', 'គ្មានពេលណាវេទនាជាងពេលដែលចេញរកសុីដំបូងនោះឡើយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90077', '0168', '01', 'ជឿអត់ថ្ងៃណាមួយខ្ញុំនិងចេញរកសុី អោយទាល់តែបានទោះខ្ញុំមានបពិសោធន៍តិចតួចក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90078', '0168', '01', 'កុំខ្វល់សម្ដីមនុស្សអវិជ្ជមាន បើអ្នកគិតល្អនិយាយល្អធ្វើល្អ អ្នកជាមនុស្សល្អហើយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90079', '0168', '01', 'ដេកទៅយប់ហើយស្អែកមានការងារត្រូវដោះស្រាយទៀត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9008', '0168', '01', 'យើងខំរកសីុលំបាកស្ទើក្ស័យពេលជោគជ័យគេថាមកពីសំណាង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90080', '0168', '01', 'ពេលវេលាមិនអាចបកស្រាយទេ កុំទុកខ្លួនឲ្យទំនេរហូតអស់ពេលបំពេញក្ដីស្រម៉ៃ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90081', '0168', '01', 'គ្មានអ្វីបានមកដោយស្រួលៗទេ កុំរំពឹងលើវាសនា ត្រូវរំពឹងលើការប្រឹងប្រែងរបស់ខ្លួន', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90082', '0168', '01', 'មុនធ្វើអ្វី ត្រូវគិតបើធ្វើដោយមិនគិតប្រយ័ត្នមានវប្បដិសារិ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90083', '0168', '01', 'គេប្រឹងណាស់ទើបមាន មិនមែនអង្គុយស្ងៀមៗ លុយធ្លាក់ពីលើមេឃទេ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90084', '0168', '01', 'ឳពុកខ្ញុំបង្រៀនខ្ញុំថាបើខ្លួនពូកែកុំមើលងាយអ្នកដទៃ បើកូនបរាជ័យកុំបាក់ទឹកចត្ត', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90085', '0168', '01', 'ភាពក្រែចិត្តរបស់អ្នកដទៃ គឺសេចក្ដីថ្លៃថ្នូវររបស់យើង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90086', '0168', '01', 'ធ្វើជាមនុស្សកុំមានអំនួត កាត់តែអួត គេកាន់ជ្រេញ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90087', '0168', '01', 'មិនមែនខ្ញុំមិនដឹងនោះទេ ប៉ុន្ដែមានពេលខ្លះមនុស្សឆ្លាតក៏ត្រូវធ្វើល្ងង់ដែរ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90088', '0168', '01', 'យើងគ្មានទ្រព្យធន សម្ដីក៏គ្មានន័យ តែបើយើងមានលុយពេញដៃសម្ដីប្រៃជាអំបិល', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90089', '0168', '01', 'កើតមកជាមនុស្សត្រូវតែរឹងមាំ ទោះត្រូវធ្លាក់ដល់កម្រិតណាក៏ដោយ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-9009', '0168', '01', 'ចង់រស់បានសុខកុំបំពានអ្នកដទៃចង់ឲ្យជីវិតមានន័យត្រូវជួយដល់អ្នកដទៃឲ្យបានច្រើន', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90090', '0168', '01', 'គិតឲ្យជ្រៅធ្វើឲ្យលះទើបសម្រេចគោលដៅ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90091', '0168', '01', 'ការតស៊ូគឺជាស្ពានចម្លងអ្នកទៅរកភាពជោគជ័យ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90092', '0168', '01', 'កុំទាន់ហឺហា ដរាបណាប្រាក់ខែនៅតិច ចំណូលនៅស្ទើ ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90093', '0168', '01', 'តាមរកក្ដីស្រម៉ៃអ្នកឲ្យឃើញទោះតាមដល់ជើងមេឃក៏ត្រូវរកឲ្យឃើញដែរ', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90094', '0168', '01', 'រាល់ថ្ងៃខំប្រឹងណាស់សង្ឃឹមថាថ្ងៃក្រោយនឹងមានផ្ទះតូចមួយជាកាដូសម្រាប់ខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90095', '0168', '01', 'មិនពង្រឹងសមត្ថភាពឲ្យកាន់តែពូកែ ស្មើនិងបំផ្លាញ់ឧកាសខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90096', '0168', '01', 'ការផ្លាស់ប្ដូរមិនមែនស្រួលទេតែវានិងធ្វើឲ្យយើងរីកចម្រើន', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90097', '0168', '01', ' កុំចាញ់ជាមួយបញ្ហា ត្រូវសន្យានឹងខ្លួនឯងថាយ៉ាងណាក៏មិនបោះបង់ព្រោះវាជាក្ដីស្រម៉ៃរបស់យើង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90098', '0168', '01', 'ផ្លូវជីវិតនៅវែងឆ្ងាយណាស់ កុំគិតតែរឿងសប្បាយរហូតភ្លេចគិតពីអនាគតខ្លួនឯង', 'IT.SYTEM', '2021-08-14 04:51:16'),
('0168-90099', '0168', '01', 'កុំថ្មមខ្លួនពេកទាន់វ័យនៅក្មេងប្រឹងរកលុយណាស់ ក្រែង៥ឆ្នាំក្រោយជីវិតប្រសើរជាងនេះ', 'IT.SYTEM', '2021-08-14 04:51:16');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_count_stock`
--

CREATE TABLE `pos_tbl_count_stock` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `stockcode` varchar(20) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_count_stock`
--

INSERT INTO `pos_tbl_count_stock` (`tran_code`, `branchcode`, `stockcode`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `sys_token`) VALUES
('0001', '0004', '0004-0004', 'count stock in March', 'technodemo@gmail.com', '2021-03-30 02:07:47', 'technodemo@gmail.com', '2021-03-30 02:07:53', '0004-606287f3c2de4'),
('0001', '0168', '0168-0004', 'for march', 'bongratha@gmail.com', '2021-03-31 09:28:55', 'bongratha@gmail.com', '2021-03-31 09:29:37', '0168-606440d6f2f68'),
('0004', '0004', '0004-0004', 'Phnom penh', 'technodemo@gmail.com', '2021-03-30 02:09:23', 'technodemo@gmail.com', '2021-03-30 02:09:36', '0004-606288535c845'),
('0007', '0001', '0001-0001', 'sell home', 'bongmap@gmail.com', '2021-03-27 17:04:19', 'bongmap@gmail.com', '2021-03-27 22:21:27', '0001-605f032380652'),
('0007', '0004', '0004-0004', 'Remark sale', 'technodemo@gmail.com', '2021-03-30 02:19:39', 'technodemo@gmail.com', '2021-03-30 02:19:59', '0004-60628abbdd108'),
('0010', '0004', '0004-0004', 'sell home', 'technodemo@gmail.com', '2021-03-30 02:28:23', 'technodemo@gmail.com', '2021-03-30 02:29:38', '0004-60628cc7ac37a'),
('0013', '0004', '0004-0004', 'Remark sale', 'technodemo@gmail.com', '2021-03-30 02:30:38', 'technodemo@gmail.com', '2021-03-30 02:30:46', '0004-60628d4e38b2d'),
('0015', '0168', '0168-0004', 'Purchase old month', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:21', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31', '0168-606db681c7711'),
('0016', '0001', '0001-0001', NULL, 'bongmap@gmail.com', '2021-03-27 22:22:17', 'bongmap@gmail.com', '2021-03-27 22:22:21', '0001-605f4da92ad49'),
('0016', '0004', '0004-0004', 'Remark sale', 'technodemo@gmail.com', '2021-03-30 02:38:27', 'technodemo@gmail.com', '2021-03-30 02:38:34', '0004-60628f23b0b7c'),
('0019', '0001', '0001-0001', '33333', 'bongmap@gmail.com', '2021-03-28 08:11:40', 'bongmap@gmail.com', '2021-03-28 08:11:49', '0001-605fd7ccc7c17'),
('0019', '0004', '0004-0004', 'Remark sale', 'technodemo@gmail.com', '2021-03-30 02:39:53', 'technodemo@gmail.com', '2021-03-30 02:40:00', '0004-60628f790be66'),
('0019', '0168', '0168-0004', 'Purchase old month', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:22', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39', '0168-606db682c411c'),
('0022', '0001', '0001-0001', 'Remark sale', 'bongmap@gmail.com', '2021-03-28 12:26:01', 'bongmap@gmail.com', '2021-03-28 12:26:09', '0001-6060136985b92'),
('0022', '0004', '0004-0004', 'Remark sale', 'technodemo@gmail.com', '2021-03-30 02:42:24', 'technodemo@gmail.com', '2021-03-30 02:42:47', '0004-60629010804d2'),
('0023', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-04-07 13:58:48', 'TECHNOZOON@gmail.com', '2021-04-07 13:58:54', '0168-606dba982552a'),
('0025', '0004', '0004-0005', 'sss', 'technodemo@gmail.com', '2021-04-09 06:09:40', 'technodemo@gmail.com', '2021-04-09 06:09:45', '0004-606fefa444db0'),
('0026', '0001', '0001-0001', 'Remark sale', 'bongmap@gmail.com', '2021-03-28 21:23:26', 'bongmap@gmail.com', '2021-03-28 22:30:30', '0001-6060915e93948'),
('0027', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-04-09 10:50:30', 'bongratha@gmail.com', '2021-04-09 10:50:36', '0168-607031766e771'),
('0030', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-04-09 11:02:21', 'bongratha@gmail.com', '2021-04-09 11:02:25', '0168-6070343d73efb'),
('0032', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-04-09 11:06:07', 'bongratha@gmail.com', '2021-04-09 11:06:13', '0168-6070351f539f7'),
('0034', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-04-13 08:31:38', 'bongratha@gmail.com', '2021-04-13 08:32:02', '0168-607556ea8641c'),
('0036', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-04-13 08:31:56', 'bongratha@gmail.com', '2021-04-13 08:32:07', '0168-607556fc780f1'),
('0038', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-04-13 08:59:33', 'bongratha@gmail.com', '2021-04-13 08:59:38', '0168-60755d7531396'),
('0040', '0168', '0168-0004', 'n/a', 'bongratha@gmail.com', '2021-04-13 09:04:48', 'bongratha@gmail.com', '2021-04-13 09:04:54', '0168-60755eb0659f5'),
('0042', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-04-13 09:30:26', 'TECHNOZOON@gmail.com', '2021-04-13 09:30:34', '0168-607564b2906aa'),
('0045', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-04-30 06:24:54', 'TECHNOZOON@gmail.com', '2021-04-30 06:24:59', '0168-608ba2b682f64'),
('0047', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-04-30 14:04:35', 'TECHNOZOON@gmail.com', '2021-04-30 14:04:41', '0168-608c0e7398f50'),
('0049', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-05-13 06:50:11', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08', '0168-609ccc22f2010'),
('0058', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-05-13 07:51:31', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25', '0168-609cda8387966'),
('0068', '0168', '0168-0004', NULL, 'bongratha@gmail.com', '2021-05-13 08:05:41', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12', '0168-609cddd5422c9'),
('0072', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-05-17 09:00:53', 'TECHNOZOON@gmail.com', '2021-05-17 09:00:57', '0168-60a230c596e7e'),
('0075', '0168', '0168-0004', 'Booking duplicate', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:30', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35', '0168-60b45d0678710'),
('0079', '0168', '0168-0004', 'N/A', 'Sale@gmail.com', '2021-05-31 09:15:56', 'Sale@gmail.com', '2021-05-31 09:16:05', '0168-60b4a94cd2553'),
('0089', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 09:21:56', 'TECHNOZOON@gmail.com', '2021-05-31 09:22:00', '0168-60b4aab495355'),
('0091', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-06-30 08:47:56', 'TECHNOZOON@gmail.com', '2021-06-30 08:48:00', '0168-60dc2fbc96d52'),
('0094', '0168', '0168-0004', 'N/A', 'Sale@gmail.com', '2021-06-30 08:59:09', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02', '0168-60dc325da5d5d'),
('0119', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-07-08 04:04:12', 'TECHNOZOON@gmail.com', '2021-07-08 04:04:17', '0168-60e6793c64657'),
('0121', '0168', '0168-0004', NULL, 'TECHNOZOON@gmail.com', '2021-07-13 03:15:59', 'TECHNOZOON@gmail.com', '2021-07-13 03:16:04', '0168-60ed056f464f0'),
('0123', '0168', '0168-0004', 'N/A', 'Sale@gmail.com', '2021-07-31 03:21:34', 'Sale@gmail.com', '2021-07-31 03:21:44', '0168-6104c1be3c3ea'),
('0145', '0168', '0168-0004', NULL, 'technozoon@gmail.com', '2021-09-01 01:40:44', 'technozoon@gmail.com', '2021-09-01 01:40:48', '0168-612eda1cb2b7a'),
('0147', '0168', '0168-0004', NULL, 'technozoon@gmail.com', '2021-09-01 01:44:25', 'technozoon@gmail.com', '2021-09-01 01:44:29', '0168-612edaf933263'),
('0149', '0168', '0168-0004', NULL, 'technozoon@gmail.com', '2021-09-01 01:48:12', 'technozoon@gmail.com', '2021-09-01 01:48:16', '0168-612edbdc2e841'),
('0153', '0168', '0168-0004', NULL, 'sale@gmail.com', '2021-09-01 03:51:35', 'technozoon@gmail.com', '2021-09-01 14:14:05', '0168-612ef8c720052');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_count_stock_detail`
--

CREATE TABLE `pos_tbl_count_stock_detail` (
  `sysdocnum` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `tran_code` varchar(20) DEFAULT NULL,
  `pro_code` varchar(20) DEFAULT NULL,
  `barcode` varchar(20) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_count_stock_detail`
--

INSERT INTO `pos_tbl_count_stock_detail` (`sysdocnum`, `branchcode`, `tran_code`, `pro_code`, `barcode`, `qty`) VALUES
('0002', '0168', '0001', '0168-0001', 'A0001', '1.00'),
('0003', '0168', '0001', '0168-0002', 'A0002', '1.00'),
('0004', '0168', '0001', '0168-0013', 'B0006', '1.00'),
('0005', '0168', '0001', '0168-0014', 'B0007', '1.00'),
('0006', '0168', '0001', '0168-0008', 'B0001', '1.00'),
('0007', '0168', '0001', '0168-0009', 'B0002', '1.00'),
('0008', '0168', '0001', '0168-0010', 'B0003', '1.00'),
('0009', '0168', '0001', '0168-0011', 'B0004', '1.00'),
('0010', '0168', '0001', '0168-0012', 'B0005', '1.00'),
('0011', '0004', '0010', '0004-0001', 'A0001', '10.00'),
('0011', '0168', '0001', '0168-0016', 'B0009', '1.00'),
('0012', '0004', '0010', '0004-0002', 'A0002', '20.00'),
('0012', '0168', '0001', '0168-0015', 'B0008', '1.00'),
('0013', '0168', '0001', '0168-0003', 'A0003', '1.00'),
('0014', '0004', '0013', '0004-0001', 'A0001', '10.00'),
('0014', '0168', '0001', '0168-0004', 'A0004', '1.00'),
('0015', '0004', '0013', '0004-0002', 'A0002', '100.00'),
('0016', '0168', '0015', '0168-0006', 'A0006', '2.00'),
('0017', '0004', '0016', '0004-0001', 'A0001', '110.00'),
('0017', '0168', '0015', '0168-0007', 'A0007', '2.00'),
('0018', '0004', '0016', '0004-0002', 'A0002', '220.00'),
('0018', '0168', '0015', '0168-0017', 'B0010', '2.00'),
('0020', '0004', '0019', '0004-0001', 'A0001', '110.00'),
('0020', '0168', '0019', '0168-0006', 'A0006', '2.00'),
('0021', '0004', '0019', '0004-0002', 'A0002', '220.00'),
('0021', '0168', '0019', '0168-0007', 'A0007', '2.00'),
('0022', '0168', '0019', '0168-0017', 'B0010', '2.00'),
('0023', '0004', '0022', '0004-0001', 'A0001', '100.00'),
('0024', '0004', '0022', '0004-0002', 'A0002', '220.00'),
('0024', '0168', '0023', '0168-0018', 'B00011', '3.00'),
('0026', '0004', '0025', '0004-0001', 'A0001', '150.00'),
('0028', '0168', '0027', '0168-0009', 'B0002', '1.00'),
('0029', '0168', '0027', '0168-0006', 'A0006', '2.00'),
('0031', '0168', '0030', '0168-0006', 'A0006', '1.00'),
('0033', '0168', '0032', '0168-0013', 'B0006', '6.00'),
('0035', '0168', '0034', '0168-0021', 'B0013', '9.00'),
('0037', '0168', '0036', '0168-0020', 'b00012', '1.00'),
('0039', '0168', '0038', '0168-0017', 'B0010', '1.00'),
('0041', '0168', '0040', '0168-0021', 'B0013', '8.00'),
('0043', '0168', '0042', '0168-0017', 'B0010', '0.00'),
('0044', '0168', '0042', '0168-0020', 'b00012', '0.00'),
('0046', '0168', '0045', '0168-0006', 'A0006', '2.00'),
('0048', '0168', '0047', '0168-0005', 'A0005', '2.00'),
('0050', '0168', '0049', '0168-0031', '0034', '10.00'),
('0051', '0168', '0049', '0168-0032', '0035', '10.00'),
('0052', '0168', '0049', '0168-0033', '0036', '10.00'),
('0053', '0168', '0049', '0168-0034', '0037', '5.00'),
('0054', '0168', '0049', '0168-0030', 'B0021', '5.00'),
('0055', '0168', '0049', '0168-0029', '0033', '5.00'),
('0056', '0168', '0049', '0168-0037', '0040', '3.00'),
('0057', '0168', '0049', '0168-0036', '0039', '3.00'),
('0059', '0168', '0058', '0168-0003', 'A0003', '1.00'),
('0060', '0168', '0058', '0168-0006', 'A0006', '1.00'),
('0061', '0168', '0058', '0168-0007', 'A0007', '2.00'),
('0062', '0168', '0058', '0168-0005', 'A0005', '2.00'),
('0063', '0168', '0058', '0168-0009', 'B0002', '1.00'),
('0064', '0168', '0058', '0168-0008', 'B0001', '1.00'),
('0065', '0168', '0058', '0168-0010', 'B0003', '4.00'),
('0066', '0168', '0058', '0168-0019', 'B0012', '2.00'),
('0067', '0168', '0058', '0168-0013', 'B0006', '5.00'),
('0069', '0168', '0068', '0168-0016', 'B0009', '1.00'),
('0070', '0168', '0068', '0168-0040', '0043', '1.00'),
('0071', '0168', '0068', '0168-0038', '0041', '1.00'),
('0073', '0168', '0072', '0168-0027', 'B0019', '0.00'),
('0074', '0168', '0072', '0168-0028', 'B0020', '0.00'),
('0076', '0168', '0075', '0168-0031', '0034', '0.00'),
('0077', '0168', '0075', '0168-0032', '0035', '0.00'),
('0078', '0168', '0075', '0168-0033', '0036', '0.00'),
('0080', '0168', '0079', '0168-0019', 'B0012', '1.00'),
('0081', '0168', '0079', '0168-0022', 'B0014', '1.00'),
('0082', '0168', '0079', '0168-0036', '0039', '3.00'),
('0083', '0168', '0079', '0168-0037', '0040', '3.00'),
('0084', '0168', '0079', '0168-0021', 'B0013', '4.00'),
('0085', '0168', '0079', '0168-0024', 'B0016', '7.00'),
('0086', '0168', '0079', '0168-0025', 'B0017', '9.00'),
('0087', '0168', '0079', '0168-0026', 'B0018', '10.00'),
('0088', '0168', '0079', '0168-0042', 'B0045', '2.00'),
('0090', '0168', '0089', '0168-0028', 'B0020', '0.00'),
('0092', '0168', '0091', '0168-0032', '0035', '0.00'),
('0093', '0168', '0091', '0168-0033', '0036', '0.00'),
('0095', '0168', '0094', '0168-0003', 'A0003', '1.00'),
('0096', '0168', '0094', '0168-0004', 'A0004', '1.00'),
('0097', '0168', '0094', '0168-0005', 'A0005', '2.00'),
('0098', '0168', '0094', '0168-0006', 'A0006', '1.00'),
('0099', '0168', '0094', '0168-0007', 'A0007', '2.00'),
('0100', '0168', '0094', '0168-0008', 'B0001', '1.00'),
('0101', '0168', '0094', '0168-0009', 'B0002', '1.00'),
('0102', '0168', '0094', '0168-0010', 'B0003', '4.00'),
('0103', '0168', '0094', '0168-0011', 'B0004', '1.00'),
('0104', '0168', '0094', '0168-0013', 'B0006', '5.00'),
('0105', '0168', '0094', '0168-0014', 'B0007', '1.00'),
('0106', '0168', '0094', '0168-0021', 'B0013', '6.00'),
('0107', '0168', '0094', '0168-0022', 'B0014', '1.00'),
('0108', '0168', '0094', '0168-0024', 'B0016', '4.00'),
('0109', '0168', '0094', '0168-0025', 'B0017', '4.00'),
('0110', '0168', '0094', '0168-0026', 'B0018', '10.00'),
('0111', '0168', '0094', '0168-0029', '0033', '7.00'),
('0112', '0168', '0094', '0168-0035', '0038', '3.00'),
('0113', '0168', '0094', '0168-0034', '0037', '4.00'),
('0114', '0168', '0094', '0168-0036', '0039', '3.00'),
('0115', '0168', '0094', '0168-0037', '0040', '3.00'),
('0116', '0168', '0094', '0168-0040', '0043', '1.00'),
('0117', '0168', '0094', '0168-0038', '0041', '1.00'),
('0118', '0168', '0094', '0168-0042', 'B0045', '2.00'),
('0120', '0168', '0119', '0168-0035', '0038', '0.00'),
('0122', '0168', '0121', '0168-0024', 'B0016', '0.00'),
('0124', '0168', '0123', '0168-0029', '0033', '5.00'),
('0125', '0168', '0123', '0168-0034', '0037', '4.00'),
('0126', '0168', '0123', '0168-0043', 'B0046', '10.00'),
('0127', '0168', '0123', '0168-0022', 'B0014', '1.00'),
('0128', '0168', '0123', '0168-0023', 'B0015', '2.00'),
('0129', '0168', '0123', '0168-0036', '0039', '2.00'),
('0130', '0168', '0123', '0168-0037', '0040', '2.00'),
('0131', '0168', '0123', '0168-0021', 'B0013', '6.00'),
('0132', '0168', '0123', '0168-0005', 'A0005', '2.00'),
('0133', '0168', '0123', '0168-0006', 'A0006', '1.00'),
('0134', '0168', '0123', '0168-0007', 'A0007', '2.00'),
('0135', '0168', '0123', '0168-0024', 'B0016', '7.00'),
('0136', '0168', '0123', '0168-0026', 'B0018', '8.00'),
('0137', '0168', '0123', '0168-0013', 'B0006', '5.00'),
('0138', '0168', '0123', '0168-0014', 'B0007', '1.00'),
('0139', '0168', '0123', '0168-0038', '0041', '1.00'),
('0140', '0168', '0123', '0168-0010', 'B0003', '4.00'),
('0141', '0168', '0123', '0168-0004', 'A0004', '1.00'),
('0142', '0168', '0123', '0168-0008', 'B0001', '1.00'),
('0143', '0168', '0123', '0168-0009', 'B0002', '1.00'),
('0144', '0168', '0123', '0168-0011', 'B0004', '1.00'),
('0146', '0168', '0145', '0168-0032', '0035', '0.00'),
('0148', '0168', '0147', '0168-0026', 'B0018', '2.00'),
('0150', '0168', '0149', '0168-0035', '0038', '0.00'),
('0154', '0168', '0153', '0168-0030', 'B0021', '9.00'),
('0155', '0168', '0153', '0168-0034', '0037', '4.00'),
('0156', '0168', '0153', '0168-0019', 'B0012', '1.00'),
('0157', '0168', '0153', '0168-0013', 'B0006', '4.00'),
('0158', '0168', '0153', '0168-0040', '0043', '1.00'),
('0159', '0168', '0153', '0168-0038', '0041', '1.00'),
('0160', '0168', '0153', '0168-0029', '0033', '4.00'),
('0161', '0168', '0153', '0168-0024', 'B0016', '13.00'),
('0162', '0168', '0153', '0168-0026', 'B0018', '3.00'),
('0163', '0168', '0153', '0168-0025', 'B0017', '4.00'),
('0164', '0168', '0153', '0168-0005', 'A0005', '2.00'),
('0165', '0168', '0153', '0168-0006', 'A0006', '1.00'),
('0166', '0168', '0153', '0168-0007', 'A0007', '2.00'),
('0167', '0168', '0153', '0168-0021', 'B0013', '5.00'),
('0168', '0168', '0153', '0168-0042', 'B0045', '2.00'),
('0169', '0168', '0153', '0168-0010', 'B0003', '2.00'),
('0170', '0168', '0153', '0168-0008', 'B0001', '1.00'),
('0171', '0168', '0153', '0168-0009', 'B0002', '1.00'),
('0172', '0168', '0153', '0168-0036', '0039', '2.00'),
('0173', '0168', '0153', '0168-0037', '0040', '2.00'),
('0174', '0168', '0153', '0168-0044', 'B00047', '1.00');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_customers`
--

CREATE TABLE `pos_tbl_customers` (
  `cus_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `cus_name` varchar(150) DEFAULT NULL,
  `cus_type` varchar(10) DEFAULT NULL,
  `inactive` varchar(10) DEFAULT NULL,
  `cus_gender` varchar(10) DEFAULT NULL,
  `cus_phone` varchar(50) DEFAULT NULL,
  `cus_email` varchar(50) DEFAULT NULL,
  `cus_province` varchar(10) DEFAULT NULL,
  `cus_district` varchar(10) DEFAULT NULL,
  `cus_commune` varchar(10) DEFAULT NULL,
  `cus_village` varchar(10) DEFAULT NULL,
  `cus_address` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_customer_type`
--

CREATE TABLE `pos_tbl_customer_type` (
  `typ_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `typ_name` varchar(150) DEFAULT NULL,
  `typ_inactive` int(11) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_document_file`
--

CREATE TABLE `pos_tbl_document_file` (
  `sysdonum` varchar(20) NOT NULL,
  `trancode` varchar(20) DEFAULT NULL,
  `branchcode` varchar(20) NOT NULL,
  `file_path` varchar(250) DEFAULT NULL,
  `file_name` varchar(250) DEFAULT NULL,
  `org_name` varchar(250) DEFAULT NULL,
  `file_ext` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_document_file`
--

INSERT INTO `pos_tbl_document_file` (`sysdonum`, `trancode`, `branchcode`, `file_path`, `file_name`, `org_name`, `file_ext`, `status`, `inputter`, `inputdate`) VALUES
('0168-0021', '0168-0028', '0168', 'pos/expense/', '0168-161770093588.png', 'TA_CONTRACT_1617700042219.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 09:22:15'),
('0168-0022', '0168-0028', '0168', 'pos/expense/', '0168-161770093526.jpg', 'photo_2021-04-06_16-14-18.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 09:22:15'),
('0168-0023', '0168-0029', '0168', 'pos/expense/', '0168-161770108991.jpg', 'photo_2021-04-06_16-14-24.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 09:24:49'),
('0168-0024', '0168-0029', '0168', 'pos/expense/', '0168-161770108980.png', 'TA_CONTRACT_1617700197483.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 09:24:49'),
('0168-0025', '0168-0030', '0168', 'pos/expense/', '0168-161770117970.jpg', 'photo_2021-04-06_16-14-29.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 09:26:19'),
('0168-0026', '0168-0030', '0168', 'pos/expense/', '0168-161770117958.png', 'TA_CONTRACT_1617700197483.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 09:26:19'),
('0168-0027', '0168-0031', '0168', 'pos/expense/', '0168-161770458626.jpg', 'photo_2021-04-06_17-22-28.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 10:23:06'),
('0168-0028', '0168-0032', '0168', 'pos/income', '0168-161785186420.jpg', 'photo_2021-04-08_10-02-21.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-08 03:17:44'),
('0168-0029', '0168-0032', '0168', 'pos/income', '0168-161785186470.jpg', 'photo_2021-04-08_10-14-24.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-08 03:17:44'),
('0168-0030', '0168-0033', '0168', 'pos/expense/', '0168-161793704678.jpg', 'photo_2021-04-09_08-52-20.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 02:57:26'),
('0168-0031', '0168-0034', '0168', 'pos/expense/', '0168-161793722388.jpg', 'photo_2021-04-09_09-30-17 (2).jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:00:23'),
('0168-0032', '0168-0034', '0168', 'pos/expense/', '0168-161793722386.jpg', 'photo_2021-04-09_09-30-17.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:00:23'),
('0168-0035', '0168-0036', '0168', 'pos/expense/', '0168-161793741654.jpg', 'photo_2021-04-09_08-51-33.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:03:36'),
('0168-0036', '0168-0036', '0168', 'pos/expense/', '0168-161793741698.png', 'TA_CONTRACT_1617935691022.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:03:36'),
('0168-0037', '0168-0037', '0168', 'pos/expense/', '0168-161793754593.jpg', 'photo_2021-04-08_10-54-14.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:05:45'),
('0168-0038', '0168-0037', '0168', 'pos/expense/', '0168-161793754534.png', 'TA_CONTRACT_1617935559554.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:05:45'),
('0168-0039', '0168-0038', '0168', 'pos/expense/', '0168-161806210083.jpg', 'photo_2021-04-10_.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-10 13:41:41'),
('0168-0040', '0168-0038', '0168', 'pos/expense/', '0168-16180621015.jpg', 'photo_2021-04-10.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-10 13:41:41'),
('0168-0041', '0168-0039', '0168', 'pos/income', '0168-161806220844.jpg', 'photo_2021-04-10_20-38-48.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-10 13:43:28'),
('0168-0042', '0168-0040', '0168', 'pos/expense/', '0168-161822311234.jpg', 'F444860B-9517-4984-A71E-9BDB6E329029.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-12 10:25:12'),
('0168-0043', '0168-0040', '0168', 'pos/expense/', '0168-161822311282.png', '0C42203E-23DE-4D1C-B70E-3CC34C743D96.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-12 10:25:12'),
('0168-0044', '0168-0040', '0168', 'pos/expense/', '0168-161822311284.png', '1D10BC30-2FDE-401D-88B8-46097A592C5E.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-12 10:25:12'),
('0168-0045', '0168-0041', '0168', 'pos/income', '0168-161829857430.jpg', 'photo_2021-04-13_14-11-32.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:55'),
('0168-0046', '0168-0041', '0168', 'pos/income', '0168-161829857599.jpg', 'photo_2021-04-13_14-11-42.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:55'),
('0168-0047', '0168-0041', '0168', 'pos/income', '0168-161829857510.jpg', 'photo_2021-04-13_14-11-39.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:55'),
('0168-0048', '0168-0042', '0168', 'pos/income', '0168-161846870039.png', 'E1CFF721-30A1-4CEA-91F5-E1B7F9D0B39A.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-04-15 06:38:21'),
('0168-0049', '0168-0042', '0168', 'pos/income', '0168-161846870181.jpg', 'D773FC38-6178-47D8-8059-5A551C1904E6.jpeg', '.jpeg', 'income', 'TECHNOZOON@gmail.com', '2021-04-15 06:38:21'),
('0168-0050', '0168-0043', '0168', 'pos/expense/', '0168-161901112798.jpg', 'photo_2021-04-21_20-18-04.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-21 13:18:47'),
('0168-0051', '0168-0043', '0168', 'pos/expense/', '0168-161901112773.jpg', 'photo_2021-04-21_20-18-11.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-21 13:18:47'),
('0168-0052', '0168-0044', '0168', 'pos/expense/', '0168-161925130891.jpg', 'photo_2021-04-24_14-52-48.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-24 08:01:48'),
('0168-0053', '0168-0045', '0168', 'pos/expense/', '0168-161925133441.jpg', 'photo_2021-04-24_14-52-37.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-24 08:02:15'),
('0168-0072', '0168-0055', '0168', 'pos/expense/', '0168-161951458460.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:44'),
('0168-0073', '0168-0055', '0168', 'pos/expense/', '0168-16195145845.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:44'),
('0168-0080', '0168-0059', '0168', 'pos/income', '0168-161953300827.jpg', 'photo_2021-04-27_21-14-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-27 14:16:48'),
('0168-0081', '0168-0060', '0168', 'pos/income', '0168-161958021312.jpg', 'Razer mouse.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-28 03:23:33'),
('0168-0082', '0168-0061', '0168', 'pos/expense/', '0168-161987425020.jpg', 'photo_2021-05-01_20-03-21.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-01 13:04:10'),
('0168-0083', '0168-0061', '0168', 'pos/expense/', '0168-16198742501.jpg', 'photo_2021-05-01_20-03-30.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-01 13:04:10'),
('0168-0084', '0168-0062', '0168', 'pos/expense/', '0168-162002587877.jpg', 'Battery.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-03 07:11:18'),
('0168-0085', '0168-0063', '0168', 'pos/income', '0168-162002625966.png', '0019.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-03 07:17:39'),
('0168-0086', '0168-0063', '0168', 'pos/income', '0168-162002625917.png', '0020.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-03 07:17:39'),
('0168-0087', '0168-0064', '0168', 'pos/income', '0168-162020800788.jpg', '780854C8-D753-4F8F-83C4-CDC96E011845.jpeg', '.jpeg', 'income', 'TECHNOZOON@gmail.com', '2021-05-05 09:46:47'),
('0168-0088', '0168-0065', '0168', 'pos/income', '0168-162022495824.jpg', 'IMG_20210505_212835_015.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-05 14:29:18'),
('0168-0090', '0168-0067', '0168', 'pos/income', '0168-162034395332.png', 'B94B85FC-C893-4733-9D70-5F2699104CF6.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-06 23:32:33'),
('0168-0091', '0168-0068', '0168', 'pos/expense/', '0168-162034457861.jpg', '6574732D-CC34-4495-B393-152DAC32C9E2.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-06 23:42:58'),
('0168-0092', '0168-0068', '0168', 'pos/expense/', '0168-162034457899.jpg', 'F1299081-2B8F-49B0-952D-8896A83651B5.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-06 23:42:58'),
('0168-0093', '0168-0069', '0168', 'pos/income', '0168-162044915313.jpg', 'B757FBD8-4434-491F-B0C5-C5FD7F6DC90B.jpeg', '.jpeg', 'income', 'TECHNOZOON@gmail.com', '2021-05-08 04:45:53'),
('0168-0094', '0168-0073', '0168', 'pos/income', '0168-162079666485.jpg', 'photo_2021-05-12_12-17-31.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-12 05:17:45'),
('0168-0095', '0168-0074', '0168', 'pos/income', '0168-162096565658.jpg', 'photo_2021-05-13_13-07-34.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:16'),
('0168-0096', '0168-0074', '0168', 'pos/income', '0168-162096565653.jpg', 'photo_2021-05-13_13-07-35.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:16'),
('0168-0097', '0168-0075', '0168', 'pos/income', '0168-162096569292.jpg', 'photo_2021-05-14_11-12-47.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:52'),
('0168-0098', '0168-0076', '0168', 'pos/expense/', '0168-162104560527.jpg', '5ABA2514C5EC6B9F78626CFC84E23774.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-15 02:26:45'),
('0168-0099', '0168-0076', '0168', 'pos/expense/', '0168-162104560568.png', 'Capture.PNG', '.PNG', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-15 02:26:45'),
('0168-0100', '0168-0077', '0168', 'pos/income', '0168-16212427286.jpg', 'photo_2021-05-17_16-11-17.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-17 09:12:09'),
('0168-0101', '0168-0078', '0168', 'pos/expense/', '0168-162142781041.jpg', 'photo_2021-05-19_19-35-48.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-19 12:36:50'),
('0168-0102', '0168-0078', '0168', 'pos/expense/', '0168-16214278109.jpg', 'photo_2021-05-19_19-35-51.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-19 12:36:50'),
('0168-0103', '0168-0079', '0168', 'pos/expense/', '0168-162160066986.jpg', 'photo_2021-05-21_19-36-13.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-21 12:37:49'),
('0168-0104', '0168-0079', '0168', 'pos/expense/', '0168-162160066935.jpg', 'photo_2021-05-21_16-52-46.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-21 12:37:49'),
('0168-0105', '0168-0080', '0168', 'pos/income', '0168-162160071865.jpg', 'photo_2021-05-21_19-36-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-21 12:38:38'),
('0168-0106', '0168-0082', '0168', 'pos/income', '0168-162165765063.jpg', 'photo_2021-05-22_11-27-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-22 04:27:30'),
('0168-0107', '0168-0091', '0168', 'pos/expense/', '0168-162191664393.jpg', 'photo_2021-05-25_11-23-10.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-25 04:24:03'),
('0168-0108', '0168-0091', '0168', 'pos/expense/', '0168-162191664312.png', 'Alibaba.PNG', '.PNG', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-25 04:24:03'),
('0168-0109', '0168-0092', '0168', 'pos/expense/', '0168-162242223328.jpg', 'photo_2021-05-31_07-49-20.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-31 00:50:33'),
('0168-0110', '0168-0092', '0168', 'pos/expense/', '0168-162242223373.jpg', 'photo_2021-05-31_07-49-24.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-31 00:50:33'),
('0168-0111', '0168-0094', '0168', 'pos/income', '0168-162242250585.jpg', 'photo_2021-05-31_07-54-51.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-31 00:55:05'),
('0168-0112', '0168-0102', '0168', 'pos/expense/', '0168-16224463908.png', 'IMG_2177.PNG', '.PNG', 'exspense', 'TECHNOZOON@gmail.com', '2021-05-31 07:33:10'),
('0168-0113', '0168-0104', '0168', 'pos/income', '0168-162298517494.jpg', 'photo_2021-06-06_17-55-15.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-06 13:12:54'),
('0168-0114', '0168-0107', '0168', 'pos/income', '0168-162339031952.jpg', 'photo_2021-06-11_12-45-11.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-11 05:45:19'),
('0168-0115', '0168-0112', '0168', 'pos/income', '0168-1623568420100.jpg', 'photo_2021-06-13_11-40-39.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-13 07:13:40'),
('0168-0116', '0168-0113', '0168', 'pos/income', '0168-162409800116.jpg', 'photo_2021-06-19_17-19-15.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-19 10:20:01'),
('0168-0117', '0168-0114', '0168', 'pos/income', '0168-162426125766.jpg', 'photo_2021-06-21_14-40-10.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-21 07:40:57'),
('0168-0118', '0168-0115', '0168', 'pos/income', '0168-162469481328.jpg', 'photo_2021-06-26_14-44-00.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-26 08:06:53'),
('0168-0119', '0168-0117', '0168', 'pos/income', '0168-162504475035.jpg', 'photo_2021-06-30_14-27-36.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-30 09:19:10'),
('0168-0120', '0168-0118', '0168', 'pos/expense/', '0168-16250635825.jpg', 'photo_2021-06-30_21-32-28.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-06-30 14:33:02'),
('0168-0121', '0168-0122', '0168', 'pos/income', '0168-162523601825.jpg', 'photo_2021-07-01_14-02-01.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-02 14:26:58'),
('0168-0122', '0168-0124', '0168', 'pos/income', '0168-162571695571.jpg', 'photo_2021-07-08_11-01-04.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-08 04:02:35'),
('0168-0123', '0168-0125', '0168', 'pos/income', '0168-162606132536.jpg', 'photo_2021-07-12_10-36-00.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-12 03:42:05'),
('0168-0124', '0168-0126', '0168', 'pos/income', '0168-162606137886.jpg', 'photo_2021-07-12_10-35-49.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-12 03:42:58'),
('0168-0125', '0168-0127', '0168', 'pos/income', '0168-162606142691.jpg', 'photo_2021-07-12_09-55-31.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-12 03:43:46'),
('0168-0126', '0168-0128', '0168', 'pos/expense/', '0168-162606289530.jpg', 'photo_2021-07-12_11-08-03.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-07-12 04:08:16'),
('0168-0127', '0168-0128', '0168', 'pos/expense/', '0168-162606289638.jpg', 'photo_2021-07-12_11-08-06.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-07-12 04:08:16'),
('0168-0128', '0168-0130', '0168', 'pos/income', '0168-162644108795.jpg', 'photo_2021-07-16_20-08-11.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-16 13:11:27'),
('0168-0129', '0168-0131', '0168', 'pos/income', '0168-162644112268.jpg', 'photo_2021-07-16_20-08-11.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-16 13:12:02'),
('0168-0130', '0168-0133', '0168', 'pos/expense/', '0168-16267651167.jpg', 'photo_2021-07-20_10-38-40.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-07-20 07:11:56'),
('0168-0131', '0168-0133', '0168', 'pos/expense/', '0168-162676511647.jpg', 'photo_2021-07-20_14-11-01.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-07-20 07:11:56'),
('0168-0132', '0168-0134', '0168', 'pos/expense/', '0168-162685512046.jpg', 'photo_2021-07-21_15-10-01.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-07-21 08:12:00'),
('0168-0133', '0168-0134', '0168', 'pos/expense/', '0168-162685512045.png', '1ce7fd94918dc8a58f0b7df2fc700481.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-07-21 08:12:00'),
('0168-0134', '0168-0135', '0168', 'pos/income', '0168-162685772541.jpg', 'photo_2021-07-21_15-54-46.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-21 08:55:25'),
('0168-0135', '0168-0135', '0168', 'pos/income', '0168-162685772523.jpg', 'photo_2021-07-21_14-30-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-21 08:55:25'),
('0168-0136', '0168-0136', '0168', 'pos/income', '0168-162753779416.jpg', 'photo_2021-07-29_12-49-39.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-29 05:49:54'),
('0168-0137', '0168-0137', '0168', 'pos/income', '0168-162764858717.jpg', 'photo_2021-07-30_13-51-00.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-30 12:36:27'),
('0168-0138', '0168-0138', '0168', 'pos/income', '0168-162769811928.jpg', 'photo_2021-07-31_08-58-46.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-31 02:22:00'),
('0168-0139', '0168-0142', '0168', 'pos/expense/', '0168-162804707221.jpg', 'photo_2021-08-04_10-09-14.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-08-04 03:17:52'),
('0168-0140', '0168-0143', '0168', 'pos/income', '0168-162814313594.jpg', 'photo_2021-08-05_12-55-53.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-08-05 05:58:55'),
('0168-0141', '0168-0144', '0168', 'pos/income', '0168-162815175415.jpg', 'photo_2021-08-05_15-17-58.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-08-05 08:22:34'),
('0168-0142', '0168-0150', '0168', 'pos/expense/', '0168-162876613315.jpg', 'photo_2021-08-12_18-01-31.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-08-12 11:02:13'),
('0168-0143', '0168-0150', '0168', 'pos/expense/', '0168-162876613367.jpg', 'photo_2021-08-12_17-57-53.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-08-12 11:02:13'),
('0168-0144', '0168-0150', '0168', 'pos/expense/', '0168-162876613339.png', 'Alibaba.PNG', '.PNG', 'exspense', 'TECHNOZOON@gmail.com', '2021-08-12 11:02:13'),
('0168-0145', '0168-0151', '0168', 'pos/income', '0168-162926079151.jpg', 'photo_2021-08-18_11-25-21.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-08-18 04:26:31'),
('0168-0146', '0168-0153', '0168', 'pos/expense/', '0168-162953753058.jpg', 'photo_2021-08-21_16-14-53.jpg', '.jpg', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:18:50'),
('0168-0147', '0168-0153', '0168', 'pos/expense/', '0168-162953753177.png', 'Capture.PNG', '.PNG', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:18:51'),
('0168-0148', '0168-0154', '0168', 'pos/expense/', '0168-1629537685100.jpg', 'photo_2021-08-21_16-20-07.jpg', '.jpg', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:21:25'),
('0168-0149', '0168-0154', '0168', 'pos/expense/', '0168-162953768547.png', 'Capture.PNG', '.PNG', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:21:25'),
('0168-0150', '0168-0155', '0168', 'pos/expense/', '0168-162953790618.jpg', 'photo_2021-08-21_16-24-44.jpg', '.jpg', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:25:06'),
('0168-0151', '0168-0155', '0168', 'pos/expense/', '0168-162953790690.png', 'Capture.PNG', '.PNG', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:25:06'),
('0168-0152', '0168-0156', '0168', 'pos/expense/', '0168-162953805828.jpg', 'photo_2021-08-21_16-26-30.jpg', '.jpg', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:27:38'),
('0168-0153', '0168-0156', '0168', 'pos/expense/', '0168-16295380582.png', 'Capture.PNG', '.PNG', 'exspense', 'technozoon@gmail.com', '2021-08-21 09:27:38'),
('0168-0154', '0168-0167', '0168', 'pos/expense/', '0168-163007268243.jpg', 'photo_2021-08-27_20-57-05.jpg', '.jpg', 'exspense', 'technozoon@gmail.com', '2021-08-27 13:58:02');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_expense`
--

CREATE TABLE `pos_tbl_expense` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `lin_id` varchar(20) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `referent` varchar(250) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `close_num` varchar(50) DEFAULT NULL,
  `close_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_expense`
--

INSERT INTO `pos_tbl_expense` (`tran_code`, `branchcode`, `lin_id`, `currency`, `amount`, `referent`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `close_num`, `close_date`) VALUES
('0168-0006', '0168', '0168-0020', '01', '48.00', 'N/A', 'buy mouse logitech G102 (3)', 'TECHNOZOON@gmail.com', '2021-04-05 09:41:21', 'TECHNOZOON@gmail.com', '2021-04-05 09:42:13', NULL, NULL),
('0168-0009', '0168', '0168-0020', '01', '1.50', 'N/A', 'Shipping from Alibaba buy SSD (6 pieces)', 'TECHNOZOON@gmail.com', '2021-04-05 09:48:39', 'TECHNOZOON@gmail.com', '2021-04-05 09:48:47', NULL, NULL),
('0168-0010', '0168', '0168-0024', '01', '3.10', 'Shipping from ZTO (TV Box & USB type C)', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 13:30:06', 'TECHNOZOON@gmail.com', '2021-04-05 13:30:55', NULL, NULL),
('0168-0028', '0168', '0168-0025', '01', '334.80', 'Buy from Alibaba', 'BX10A USB-C HUB Adapter ( 2021-03-31) Qty=10', 'TECHNOZOON@gmail.com', '2021-04-06 09:22:15', 'TECHNOZOON@gmail.com', '2021-04-06 09:39:37', NULL, NULL),
('0168-0029', '0168', '0168-0025', '01', '72.58', 'buy Car toy cars with light sound', '2021-03-31 qty=10', 'TECHNOZOON@gmail.com', '2021-04-06 09:24:49', 'TECHNOZOON@gmail.com', '2021-04-06 09:40:00', NULL, NULL),
('0168-0030', '0168', '0168-0025', '01', '113.81', 'buy Mini Pico portable Projector LED', NULL, 'TECHNOZOON@gmail.com', '2021-04-06 09:26:19', 'TECHNOZOON@gmail.com', '2021-04-06 09:39:46', NULL, NULL),
('0168-0031', '0168', '0168-0020', '01', '175.00', 'Buy Printer', NULL, 'TECHNOZOON@gmail.com', '2021-04-06 10:23:06', 'TECHNOZOON@gmail.com', '2021-04-06 10:23:37', NULL, NULL),
('0168-0033', '0168', '0168-0024', '01', '3.10', 'ZTO shipping from Alibaba', '(Razer =5 USB Typee-C = 5', 'TECHNOZOON@gmail.com', '2021-04-09 02:57:26', 'TECHNOZOON@gmail.com', '2021-04-09 02:57:39', NULL, NULL),
('0168-0034', '0168', '0168-0029', '01', '1.71', 'Facebook boost page', 'Pay on facebook page', 'TECHNOZOON@gmail.com', '2021-04-09 03:00:23', 'TECHNOZOON@gmail.com', '2021-04-09 03:00:54', NULL, NULL),
('0168-0036', '0168', '0168-0025', '01', '248.62', '82187731001021937 Order', 'Maono Cardioid Podcasting &  MAONOCASTER External Sound', 'TECHNOZOON@gmail.com', '2021-04-09 03:03:36', 'TECHNOZOON@gmail.com', '2021-04-09 03:03:52', NULL, NULL),
('0168-0037', '0168', '0168-0025', '01', '175.09', '82142059001021937Order', 'Wifi Booster  & USB wifi', 'TECHNOZOON@gmail.com', '2021-04-09 03:05:45', 'TECHNOZOON@gmail.com', '2021-04-09 03:06:04', NULL, NULL),
('0168-0038', '0168', '0168-0029', '01', '1.92', 'Facebook boost page', NULL, 'TECHNOZOON@gmail.com', '2021-04-10 13:41:40', 'TECHNOZOON@gmail.com', '2021-04-10 13:41:52', NULL, NULL),
('0168-0040', '0168', '0168-0024', '01', '7.50', 'Shipping car toy', NULL, 'TECHNOZOON@gmail.com', '2021-04-12 10:25:12', 'TECHNOZOON@gmail.com', '2021-04-12 10:25:28', NULL, NULL),
('0168-0043', '0168', '0168-0024', '01', '5.80', 'ZTO', 'LCD projectors', 'TECHNOZOON@gmail.com', '2021-04-21 13:18:47', 'TECHNOZOON@gmail.com', '2021-04-21 13:18:57', NULL, NULL),
('0168-0044', '0168', '0168-0030', '01', '200.00', 'Mr.Ratha 25-04-2021', 'Work only 14-04-2021', 'TECHNOZOON@gmail.com', '2021-04-24 08:01:48', 'TECHNOZOON@gmail.com', '2021-04-24 08:02:24', NULL, NULL),
('0168-0045', '0168', '0168-0030', '01', '30.00', 'Mr.Mike', 'Work only 14-04-2021', 'TECHNOZOON@gmail.com', '2021-04-24 08:02:14', 'TECHNOZOON@gmail.com', '2021-04-24 08:03:13', NULL, NULL),
('0168-0055', '0168', '0168-0024', '01', '4.00', 'ZTO shipping WiFi route', NULL, 'TECHNOZOON@gmail.com', '2021-04-27 09:09:44', 'TECHNOZOON@gmail.com', '2021-04-27 09:20:48', NULL, NULL),
('0168-0061', '0168', '0168-0024', '01', '5.20', 'Shipping Micro phone', NULL, 'TECHNOZOON@gmail.com', '2021-05-01 13:04:10', 'TECHNOZOON@gmail.com', '2021-05-01 13:04:19', NULL, NULL),
('0168-0062', '0168', '0168-0020', '01', '1.25', 'Buy batter for Projector (4 pcs)', 'For support remote control Projector', 'TECHNOZOON@gmail.com', '2021-05-03 07:11:18', 'TECHNOZOON@gmail.com', '2021-05-03 07:19:24', NULL, NULL),
('0168-0068', '0168', '0168-0024', '01', '8.50', 'Shipping Typ-connector', NULL, 'TECHNOZOON@gmail.com', '2021-05-06 23:42:58', 'TECHNOZOON@gmail.com', '2021-05-06 23:43:08', NULL, NULL),
('0168-0076', '0168', '0168-0025', '01', '195.69', '88473367001021937', NULL, 'TECHNOZOON@gmail.com', '2021-05-15 02:26:45', 'TECHNOZOON@gmail.com', '2021-05-15 02:26:54', NULL, NULL),
('0168-0078', '0168', '0168-0029', '01', '5.26', 'Boost like page', NULL, 'TECHNOZOON@gmail.com', '2021-05-19 12:36:50', 'TECHNOZOON@gmail.com', '2021-05-19 12:38:24', NULL, NULL),
('0168-0079', '0168', '0168-0024', '01', '5.30', 'Shipping LCD projector', NULL, 'TECHNOZOON@gmail.com', '2021-05-21 12:37:49', 'TECHNOZOON@gmail.com', '2021-05-21 12:37:56', NULL, NULL),
('0168-0091', '0168', '0168-0025', '01', '240.59', 'buy usb type-C 11 in 1', 'This price include free of visa', 'TECHNOZOON@gmail.com', '2021-05-25 04:24:03', 'TECHNOZOON@gmail.com', '2021-05-25 04:24:11', NULL, NULL),
('0168-0092', '0168', '0168-0020', '01', '2000.00', 'Mr.Ratha request money back 2000$', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 00:50:33', 'TECHNOZOON@gmail.com', '2021-05-31 00:50:40', NULL, NULL),
('0168-0100', '0168', '0168-0030', '01', '150.00', 'Provide salary only 150$ for Mr.Ratha', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 07:26:23', 'TECHNOZOON@gmail.com', '2021-05-31 07:33:22', NULL, NULL),
('0168-0102', '0168', '0168-0030', '01', '20.00', 'Provide salary only 20$ for Mr.Mai', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 07:33:10', 'TECHNOZOON@gmail.com', '2021-05-31 07:33:18', NULL, NULL),
('0168-0103', '0168', '0168-0020', '01', '5.00', 'Refun to customer buy 11 in 1 to get 10 in 1', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 09:32:11', 'TECHNOZOON@gmail.com', '2021-05-31 09:32:17', NULL, NULL),
('0168-0118', '0168', '0168-0030', '01', '55.00', 'For bonus in June', 'For June', 'TECHNOZOON@gmail.com', '2021-06-30 14:33:02', 'TECHNOZOON@gmail.com', '2021-06-30 14:34:50', NULL, NULL),
('0168-0120', '0168', '0168-0030', '01', '20.00', 'Mr.Mai for bonus shipping product', 'Mai for bonus shipping product', 'TECHNOZOON@gmail.com', '2021-06-30 14:34:15', 'TECHNOZOON@gmail.com', '2021-06-30 14:34:54', NULL, NULL),
('0168-0121', '0168', '0168-0030', '01', '20.00', 'Mr.Makara for bonus shipping product', NULL, 'TECHNOZOON@gmail.com', '2021-06-30 14:34:45', 'TECHNOZOON@gmail.com', '2021-06-30 14:34:58', NULL, NULL),
('0168-0128', '0168', '0168-0025', '01', '308.97', 'buy product online', NULL, 'TECHNOZOON@gmail.com', '2021-07-12 04:08:15', 'TECHNOZOON@gmail.com', '2021-07-12 04:08:21', NULL, NULL),
('0168-0133', '0168', '0168-0024', '01', '3.70', 'Shipping from ZTO', NULL, 'TECHNOZOON@gmail.com', '2021-07-20 07:11:56', 'TECHNOZOON@gmail.com', '2021-07-20 07:12:00', NULL, NULL),
('0168-0134', '0168', '0168-0025', '01', '261.34', '11 in 1 usb c hub , 10 In 1 Hub Usb 3.0 Port 4k Hmi', NULL, 'TECHNOZOON@gmail.com', '2021-07-21 08:12:00', 'TECHNOZOON@gmail.com', '2021-07-21 08:12:04', NULL, NULL),
('0168-0139', '0168', '0168-0030', '01', '30.00', 'Mr.Makara', NULL, 'TECHNOZOON@gmail.com', '2021-07-31 07:11:25', 'TECHNOZOON@gmail.com', '2021-07-31 07:12:18', NULL, NULL),
('0168-0140', '0168', '0168-0030', '01', '30.00', 'Mr.Mai Salary', NULL, 'TECHNOZOON@gmail.com', '2021-07-31 07:11:38', 'TECHNOZOON@gmail.com', '2021-07-31 07:12:21', NULL, NULL),
('0168-0141', '0168', '0168-0030', '01', '35.00', 'Mr.Rotha share bonuse', NULL, 'TECHNOZOON@gmail.com', '2021-07-31 07:12:13', 'TECHNOZOON@gmail.com', '2021-07-31 07:12:25', NULL, NULL),
('0168-0142', '0168', '0168-0024', '01', '2.90', 'Shipping USB typc-10', NULL, 'TECHNOZOON@gmail.com', '2021-08-04 03:17:52', 'TECHNOZOON@gmail.com', '2021-08-04 03:17:58', NULL, NULL),
('0168-0150', '0168', '0168-0025', '01', '340.90', '103859499001021937Order', 'This product buy for test (Printer)', 'TECHNOZOON@gmail.com', '2021-08-12 11:02:13', 'TECHNOZOON@gmail.com', '2021-08-12 11:02:25', NULL, NULL),
('0168-0153', '0168', '0168-0025', '01', '218.14', 'Xiaomi Mi Wifi Booster = 20 (104316914001021937)', NULL, 'technozoon@gmail.com', '2021-08-21 09:18:50', 'technozoon@gmail.com', '2021-08-21 09:27:56', NULL, NULL),
('0168-0154', '0168', '0168-0025', '01', '126.68', 'PXN V9 wired (104817090501021937) Gaming', NULL, 'technozoon@gmail.com', '2021-08-21 09:21:25', 'technozoon@gmail.com', '2021-08-21 09:27:51', NULL, NULL),
('0168-0155', '0168', '0168-0025', '01', '121.53', 'Cooling Fan Smartphone Radiator Game  (105164391001021937)', NULL, 'technozoon@gmail.com', '2021-08-21 09:25:06', 'technozoon@gmail.com', '2021-08-21 09:27:47', NULL, NULL),
('0168-0156', '0168', '0168-0025', '01', '96.82', 'Selling Mini Mobile HD Stereo Sound  (105177183001021937)', NULL, 'technozoon@gmail.com', '2021-08-21 09:27:38', 'technozoon@gmail.com', '2021-08-21 09:27:43', NULL, NULL),
('0168-0167', '0168', '0168-0024', '01', '3.40', 'Shipping ZTO for WIfi ( Qty 20)', NULL, 'technozoon@gmail.com', '2021-08-27 13:58:02', 'technozoon@gmail.com', '2021-08-27 13:58:07', NULL, NULL),
('0168-0174', '0168', '0168-0030', '01', '55.00', 'Salary Mr.Makara', '', 'technozoon@gmail.com', '2021-08-11 02:36:26', 'technozoon@gmail.com', '2021-08-31 02:36:31', NULL, NULL),
('0168-0175', '0168', '0168-0030', '01', '15.00', 'Provide Mr.Ratha help', '', 'technozoon@gmail.com', '2021-08-11 02:36:26', 'technozoon@gmail.com', '2021-08-31 02:36:31', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_fee`
--

CREATE TABLE `pos_tbl_fee` (
  `sysnum` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `inv_num` varchar(20) DEFAULT NULL,
  `trancode` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_fee`
--

INSERT INTO `pos_tbl_fee` (`sysnum`, `branchcode`, `inv_num`, `trancode`, `amount`, `remark`, `trandate`) VALUES
('0002', '0168', '0088', '01', '2.00', 'Fee of delivery  invoice : 0088', '2021-07-01 07:51:12'),
('0003', '0168', '0106', '01', '1.00', 'Fee of delivery  invoice : 0106', '2021-07-29 03:25:10'),
('0004', '0168', '0107', '01', '2.00', 'Fee of delivery  invoice : 0107', '2021-07-30 07:14:45'),
('0005', '0168', '0108', '01', '2.00', 'Fee of delivery  invoice : 0108', '2021-08-04 06:13:59'),
('0006', '0168', '0109', '01', '1.00', 'Fee of delivery  invoice : 0109', '2021-08-05 03:19:51'),
('0008', '0168', '0111', '01', '2.00', 'Fee of delivery  invoice : 0111', '2021-08-05 06:23:59'),
('0009', '0168', '0117', '01', '1.00', 'Fee of delivery  invoice : 0117', '2021-08-18 02:45:38'),
('0010', '0168', '0121', '01', '2.00', 'Fee of delivery  invoice : 0121', '2021-08-19 01:23:56'),
('0011', '0168', '0123', '01', '2.00', 'Fee of delivery  invoice : 0123', '2021-08-19 06:28:19'),
('0012', '0168', '0124', '01', '1.00', 'Fee of delivery  invoice : 0124', '2021-08-24 06:28:29'),
('0013', '0168', '0125', '01', '1.00', 'Fee of delivery  invoice : 0125', '2021-08-24 06:30:32'),
('0014', '0168', '0126', '01', '1.00', 'Fee of delivery  invoice : 0126', '2021-08-26 01:30:39'),
('0015', '0168', '0127', '01', '1.00', 'Fee of delivery  invoice : 0127', '2021-08-27 08:31:05'),
('0016', '0168', '0128', '01', '1.00', 'Fee of delivery  invoice : 0128', '2021-08-27 08:32:47'),
('0017', '0168', '0132', '01', '2.00', 'Fee of delivery  invoice : 0132', '2021-08-30 02:59:27'),
('0018', '0168', '0133', '01', '1.00', 'Fee of delivery  invoice : 0133', '2021-08-30 07:16:42'),
('0019', '0168', '0134', '01', '1.00', 'Fee of delivery  invoice : 0134', '2021-08-30 07:17:35'),
('0020', '0168', '0135', '01', '2.00', 'Fee of delivery  invoice : 0135', '2021-08-31 06:09:27'),
('0021', '0168', '0138', '01', '2.00', 'Fee of delivery  invoice : 0138', '2021-09-04 00:59:28'),
('0022', '0168', '0139', '01', '1.00', 'Fee of delivery  invoice : 0139', '2021-09-04 06:55:04'),
('0023', '0168', '0140', '01', '1.00', 'Fee of delivery  invoice : 0140', '2021-09-05 08:15:19'),
('0024', '0168', '0141', '01', '1.00', 'Fee of delivery  invoice : 0141', '2021-09-06 01:30:36'),
('0025', '0168', '0143', '01', '1.00', 'Fee of delivery  invoice : 0143', '2021-09-07 01:52:50'),
('0026', '0168', '0145', '01', '2.00', 'Fee of delivery  invoice : 0145', '2021-09-07 03:54:17');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_income`
--

CREATE TABLE `pos_tbl_income` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `lin_id` varchar(20) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `referent` varchar(250) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `close_num` varchar(50) DEFAULT NULL,
  `close_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_income`
--

INSERT INTO `pos_tbl_income` (`tran_code`, `branchcode`, `lin_id`, `currency`, `amount`, `referent`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `close_num`, `close_date`) VALUES
('0168-0007', '0168', '0168-0019', '01', '40.00', 'N/A', 'Sold out logitech G102 (2)', 'TECHNOZOON@gmail.com', '2021-04-05 09:43:09', 'TECHNOZOON@gmail.com', '2021-04-05 09:43:14', NULL, NULL),
('0168-0008', '0168', '0168-0019', '01', '20.00', 'N/A', 'sold out Razer gaming mouse', 'TECHNOZOON@gmail.com', '2021-04-05 09:46:44', 'TECHNOZOON@gmail.com', '2021-04-05 09:46:49', NULL, NULL),
('0168-0032', '0168', '0168-0023', '01', '11.00', 'Wood table - lamp modern', NULL, 'TECHNOZOON@gmail.com', '2021-04-08 03:17:44', 'TECHNOZOON@gmail.com', '2021-04-08 03:18:25', NULL, NULL),
('0168-0039', '0168', '0168-0023', '01', '40.00', 'Sold out', 'Sell mouse logitech 2 to 087576012', 'TECHNOZOON@gmail.com', '2021-04-10 13:43:27', 'TECHNOZOON@gmail.com', '2021-04-10 13:43:37', NULL, NULL),
('0168-0041', '0168', '0168-0023', '01', '49.00', 'Bong Ratha sold car & USB type-c', '13-04-2021 sold item out', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:54', 'TECHNOZOON@gmail.com', '2021-04-13 07:23:08', NULL, NULL),
('0168-0042', '0168', '0168-0023', '01', '37.00', 'Sold TV box', 'Bong Ratha sold out', 'TECHNOZOON@gmail.com', '2021-04-15 06:38:20', 'TECHNOZOON@gmail.com', '2021-04-15 06:39:21', NULL, NULL),
('0168-0059', '0168', '0168-0023', '01', '35.00', 'Sold Out TV box', 'Customer use service to get product', 'TECHNOZOON@gmail.com', '2021-04-27 14:16:48', 'TECHNOZOON@gmail.com', '2021-04-27 14:17:00', NULL, NULL),
('0168-0060', '0168', '0168-0023', '01', '21.00', 'Razer 27-04-2021', 'Mr.Makara bring product to customer', 'TECHNOZOON@gmail.com', '2021-04-28 03:23:33', 'TECHNOZOON@gmail.com', '2021-04-28 03:23:44', NULL, NULL),
('0168-0063', '0168', '0168-0023', '01', '100.00', 'Projector LED', NULL, 'TECHNOZOON@gmail.com', '2021-05-03 07:17:39', 'TECHNOZOON@gmail.com', '2021-05-03 07:18:59', NULL, NULL),
('0168-0064', '0168', '0168-0023', '01', '37.00', 'Tv Box', NULL, 'TECHNOZOON@gmail.com', '2021-05-05 09:46:47', 'TECHNOZOON@gmail.com', '2021-05-05 14:29:37', NULL, NULL),
('0168-0065', '0168', '0168-0023', '01', '28.00', 'Sold Keyboard', NULL, 'TECHNOZOON@gmail.com', '2021-05-05 14:29:18', 'TECHNOZOON@gmail.com', '2021-05-05 14:29:56', NULL, NULL),
('0168-0067', '0168', '0168-0023', '01', '49.00', 'Projectors', 'Mr.Ratha sold out 49$ keep cash', 'TECHNOZOON@gmail.com', '2021-05-06 23:32:33', 'TECHNOZOON@gmail.com', '2021-05-06 23:32:39', NULL, NULL),
('0168-0069', '0168', '0168-0023', '01', '55.00', 'Projectors', 'Transfer to ABA Mr.Ratha to keep', 'TECHNOZOON@gmail.com', '2021-05-08 04:45:53', 'TECHNOZOON@gmail.com', '2021-05-08 04:46:00', NULL, NULL),
('0168-0070', '0168', '0168-0023', '01', '36.00', 'SSD King stone 240GB', 'SSD King stone 240GB', 'TECHNOZOON@gmail.com', '2021-05-10 05:59:22', 'TECHNOZOON@gmail.com', '2021-05-10 05:59:28', NULL, NULL),
('0168-0071', '0168', '0168-0023', '01', '55.00', 'Projector X20', 'Mr.Ratha sold out', 'TECHNOZOON@gmail.com', '2021-05-10 06:06:38', 'TECHNOZOON@gmail.com', '2021-05-10 06:06:49', NULL, NULL),
('0168-0072', '0168', '0168-0023', '01', '19.00', 'Type-C 6 in1 HDMI', 'Mr.Makara bring product', 'TECHNOZOON@gmail.com', '2021-05-11 09:40:55', 'TECHNOZOON@gmail.com', '2021-05-11 09:41:00', NULL, NULL),
('0168-0073', '0168', '0168-0023', '01', '21.50', 'Mr.Map buy to use', NULL, 'TECHNOZOON@gmail.com', '2021-05-12 05:17:44', 'TECHNOZOON@gmail.com', '2021-05-12 05:17:49', NULL, NULL),
('0168-0074', '0168', '0168-0023', '01', '47.00', 'Type-C 11 in 1', 'Mr.Ratha sold out bring to customer', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:16', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:24', NULL, NULL),
('0168-0075', '0168', '0168-0023', '01', '33.00', 'Type-C 8 in 1', 'Mr.Map bring to customer', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:52', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:58', NULL, NULL),
('0168-0077', '0168', '0168-0023', '01', '30.00', 'Car toy', 'Mr.Ratha sold out and bring to customer', 'TECHNOZOON@gmail.com', '2021-05-17 09:12:08', 'TECHNOZOON@gmail.com', '2021-05-17 09:12:14', NULL, NULL),
('0168-0080', '0168', '0168-0023', '01', '25.00', 'Mr.Map buy to use  Desk Compatible with Mac MacBook', 'Desk Compatible with Mac MacBook', 'TECHNOZOON@gmail.com', '2021-05-21 12:38:38', 'TECHNOZOON@gmail.com', '2021-05-21 12:38:43', NULL, NULL),
('0168-0082', '0168', '0168-0023', '01', '49.00', 'Type-C 11 in 1', 'Mr.Ratha sold out and bring to customer', 'TECHNOZOON@gmail.com', '2021-05-22 04:27:30', 'TECHNOZOON@gmail.com', '2021-05-22 04:27:49', NULL, NULL),
('0168-0083', '0168', '0168-0023', '01', '55.00', 'Projector X20', 'Customer come to take a way', 'TECHNOZOON@gmail.com', '2021-05-22 04:28:12', 'TECHNOZOON@gmail.com', '2021-05-22 04:28:17', NULL, NULL),
('0168-0086', '0168', '0168-0023', '01', '15.00', 'Wifi Adapter USB Ralink RT5370 Main Chip', 'Mr.Rotha bring to customer', 'TECHNOZOON@gmail.com', '2021-05-23 06:35:46', 'TECHNOZOON@gmail.com', '2021-05-23 06:35:52', NULL, NULL),
('0168-0087', '0168', '0168-0023', '01', '49.00', 'Projector LED Home Theater 1080P', 'Mr.Rotha bring to customer', 'TECHNOZOON@gmail.com', '2021-05-24 14:10:10', 'TECHNOZOON@gmail.com', '2021-05-24 14:10:15', NULL, NULL),
('0168-0088', '0168', '0168-0023', '01', '49.00', 'Type-C 11 in 1', 'Mr.Rotha bring to customer  Phone:095888360', 'TECHNOZOON@gmail.com', '2021-05-24 14:11:00', 'TECHNOZOON@gmail.com', '2021-05-24 14:11:15', NULL, NULL),
('0168-0089', '0168', '0168-0023', '01', '49.00', 'Type-C 11 in 1', 'Phone:016661135', 'TECHNOZOON@gmail.com', '2021-05-24 14:11:38', 'TECHNOZOON@gmail.com', '2021-05-24 14:11:44', NULL, NULL),
('0168-0090', '0168', '0168-0023', '01', '44.00', 'Phone:017821821', 'Mr.Rotha bring to customer Phone:017821821', 'TECHNOZOON@gmail.com', '2021-05-24 14:12:20', 'TECHNOZOON@gmail.com', '2021-05-24 14:12:26', NULL, NULL),
('0168-0093', '0168', '0168-0023', '01', '55.00', 'Mr.Ratha sell to his friend', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 00:54:14', 'TECHNOZOON@gmail.com', '2021-05-31 00:55:16', NULL, NULL),
('0168-0094', '0168', '0168-0023', '01', '60.00', 'projector send to SR 60$', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 00:55:05', 'TECHNOZOON@gmail.com', '2021-05-31 00:55:24', NULL, NULL),
('0168-0095', '0168', '0168-0023', '01', '19.00', 'Mr.Ratha bring customer  1 type-c 6 in 1', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 00:57:52', 'TECHNOZOON@gmail.com', '2021-05-31 00:58:03', NULL, NULL),
('0168-0097', '0168', '0168-0023', '01', '15.00', '0065 Mr.Ratha bring to customer', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 07:13:59', 'TECHNOZOON@gmail.com', '2021-05-31 07:14:39', NULL, NULL),
('0168-0098', '0168', '0168-0023', '01', '49.00', '0066 Mr.Ratha bring product to customer', NULL, 'TECHNOZOON@gmail.com', '2021-05-31 07:14:33', 'TECHNOZOON@gmail.com', '2021-05-31 07:14:50', NULL, NULL),
('0168-0104', '0168', '0168-0023', '01', '49.00', '0073', NULL, 'TECHNOZOON@gmail.com', '2021-06-06 13:12:54', 'TECHNOZOON@gmail.com', '2021-06-06 13:13:04', NULL, NULL),
('0168-0105', '0168', '0168-0023', '01', '15.00', 'sold Mi Wifi Booster', 'Mr.Makara bring product to customer (pay money)', 'TECHNOZOON@gmail.com', '2021-06-08 02:47:44', 'TECHNOZOON@gmail.com', '2021-06-08 02:48:33', NULL, NULL),
('0168-0106', '0168', '0168-0023', '01', '19.00', 'buy usb type-C 6  in 1', 'Mr.Makara bring product to customer (ABA to Mr.Ratha)', 'TECHNOZOON@gmail.com', '2021-06-08 02:48:25', 'TECHNOZOON@gmail.com', '2021-06-08 02:48:40', NULL, NULL),
('0168-0107', '0168', '0168-0023', '01', '15.00', 'Wireless-N wifi repeater (0076)', 'Mr.Rotha bring to customer', 'TECHNOZOON@gmail.com', '2021-06-11 05:45:19', 'TECHNOZOON@gmail.com', '2021-06-11 05:45:35', NULL, NULL),
('0168-0108', '0168', '0168-0023', '01', '12.00', 'Wifi Adapter USB Ralink RT5370 (0077)', 'Mr.Makara bring product to customer (pay money)', 'TECHNOZOON@gmail.com', '2021-06-11 05:47:10', 'TECHNOZOON@gmail.com', '2021-06-11 05:47:16', NULL, NULL),
('0168-0109', '0168', '0168-0023', '01', '12.00', 'Wifi Adapter USB Ralink RT5370 (0078)', 'Mr.Makara bring product to customer (pay money)', 'TECHNOZOON@gmail.com', '2021-06-11 05:48:08', 'TECHNOZOON@gmail.com', '2021-06-11 05:48:17', NULL, NULL),
('0168-0111', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster (0080)', 'Mr.Makara bring product to customer (pay money)', 'TECHNOZOON@gmail.com', '2021-06-13 07:07:04', 'TECHNOZOON@gmail.com', '2021-06-13 07:07:10', NULL, NULL),
('0168-0112', '0168', '0168-0023', '01', '25.00', 'Wifi Adapter USB Ralink and Mi(0080)', 'Customer come to take away', 'TECHNOZOON@gmail.com', '2021-06-13 07:13:40', 'TECHNOZOON@gmail.com', '2021-06-13 07:13:47', NULL, NULL),
('0168-0113', '0168', '0168-0023', '01', '51.00', 'Type-C 11 in 1 (0081)', 'Mr.Map bring to customer', 'TECHNOZOON@gmail.com', '2021-06-19 10:20:01', 'TECHNOZOON@gmail.com', '2021-06-19 10:20:05', NULL, NULL),
('0168-0114', '0168', '0168-0023', '01', '39.00', 'Type-C 10 in 1 USB-C HUB Adapter (0082)', 'Mr.Ratha bring to customer', 'TECHNOZOON@gmail.com', '2021-06-21 07:40:57', 'TECHNOZOON@gmail.com', '2021-06-21 07:41:07', NULL, NULL),
('0168-0115', '0168', '0168-0023', '01', '24.00', 'Wireless USB Adapter (0084-0085)', 'Mr.Makara bring item to customer', 'TECHNOZOON@gmail.com', '2021-06-26 08:06:53', 'TECHNOZOON@gmail.com', '2021-06-26 08:06:59', NULL, NULL),
('0168-0116', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0086)', 'Mr.Makra bring product to customer', 'TECHNOZOON@gmail.com', '2021-06-28 03:47:07', 'TECHNOZOON@gmail.com', '2021-06-28 03:47:15', NULL, NULL),
('0168-0117', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster (0087)', 'Mr.Ratha bring item to customer', 'TECHNOZOON@gmail.com', '2021-06-30 09:19:10', 'TECHNOZOON@gmail.com', '2021-06-30 09:19:15', NULL, NULL),
('0168-0122', '0168', '0168-0023', '01', '17.00', 'Xiaomi Mi Wifi Booster (0088)', 'Mr.Makra send this to shipping to customer province', 'TECHNOZOON@gmail.com', '2021-07-02 14:26:58', 'TECHNOZOON@gmail.com', '2021-07-02 14:27:11', NULL, NULL),
('0168-0123', '0168', '0168-0023', '01', '39.00', 'Type-C 10 in 1 USB-C HUB Adapter (0089)', 'Mr.Makara bring item to customer (Keep cash)', 'TECHNOZOON@gmail.com', '2021-07-02 14:28:03', 'TECHNOZOON@gmail.com', '2021-07-02 14:28:07', NULL, NULL),
('0168-0124', '0168', '0168-0023', '01', '39.00', 'Type-C 10 in 1 (0090)', 'Mr.Makra bring product to customer', 'TECHNOZOON@gmail.com', '2021-07-08 04:02:35', 'TECHNOZOON@gmail.com', '2021-07-08 04:02:40', NULL, NULL),
('0168-0125', '0168', '0168-0023', '01', '30.00', 'Xiaomi Mi Wifi Booster (0094)', 'Mr.Makra bring item to customer', 'TECHNOZOON@gmail.com', '2021-07-12 03:42:05', 'TECHNOZOON@gmail.com', '2021-07-12 03:43:51', NULL, NULL),
('0168-0126', '0168', '0168-0023', '01', '77.00', 'MAONO AU-AM200 CASTER (0095)', 'Mr.Mai bring item to customer', 'TECHNOZOON@gmail.com', '2021-07-12 03:42:58', 'TECHNOZOON@gmail.com', '2021-07-12 03:43:54', NULL, NULL),
('0168-0127', '0168', '0168-0023', '01', '40.00', 'Maono AU-902 Cardioid Microphone(0096)', 'Mr.Mai sould and bring to customer', 'TECHNOZOON@gmail.com', '2021-07-12 03:43:46', 'TECHNOZOON@gmail.com', '2021-07-12 03:43:59', NULL, NULL),
('0168-0129', '0168', '0168-0023', '01', '49.00', 'Type-C 11 in 1 (0098)', 'Mr.Makra bring to customer', 'TECHNOZOON@gmail.com', '2021-07-13 14:01:07', 'TECHNOZOON@gmail.com', '2021-07-13 14:01:16', NULL, NULL),
('0168-0130', '0168', '0168-0023', '01', '47.00', 'Type-C 11 in 1 (0100)', 'Mr.Makara bring to customer', 'TECHNOZOON@gmail.com', '2021-07-16 13:11:27', 'TECHNOZOON@gmail.com', '2021-07-16 13:12:07', NULL, NULL),
('0168-0131', '0168', '0168-0023', '01', '37.00', 'Type-C 10 in 1 USB-C HUB Adapter', 'Mr.Makara bring to customer', 'TECHNOZOON@gmail.com', '2021-07-16 13:12:02', 'TECHNOZOON@gmail.com', '2021-07-16 13:12:13', NULL, NULL),
('0168-0132', '0168', '0168-0023', '01', '12.00', 'USB Wifi (0102)', 'Mr.Makara item to customer and keep money', 'TECHNOZOON@gmail.com', '2021-07-20 07:09:57', 'TECHNOZOON@gmail.com', '2021-07-20 07:10:03', NULL, NULL),
('0168-0135', '0168', '0168-0023', '01', '28.75', 'Xiaomi Mi Wifi Booster (0103)', 'Mr.Mai send item to customer', 'TECHNOZOON@gmail.com', '2021-07-21 08:55:25', 'TECHNOZOON@gmail.com', '2021-07-21 08:55:30', NULL, NULL),
('0168-0136', '0168', '0168-0023', '01', '15.00', 'Wifi Mi (0106)', '1$ Pay delivery  buy card to Makra', 'TECHNOZOON@gmail.com', '2021-07-29 05:49:54', 'TECHNOZOON@gmail.com', '2021-07-29 05:50:00', NULL, NULL),
('0168-0137', '0168', '0168-0023', '01', '17.00', 'Xiaomi Mi Wifi  (0107)', 'Mr.Makra bring to customer (Makara keep money)', 'TECHNOZOON@gmail.com', '2021-07-30 12:36:27', 'TECHNOZOON@gmail.com', '2021-07-30 12:36:32', NULL, NULL),
('0168-0138', '0168', '0168-0023', '01', '20.00', 'Aula F2016 (0092)', 'Mr.Rotha bring to customer', 'TECHNOZOON@gmail.com', '2021-07-31 02:21:59', 'TECHNOZOON@gmail.com', '2021-07-31 02:22:07', NULL, NULL),
('0168-0143', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster (0109)', 'Mr.Makara delivery +1$', 'TECHNOZOON@gmail.com', '2021-08-05 05:58:55', 'TECHNOZOON@gmail.com', '2021-08-05 05:59:01', NULL, NULL),
('0168-0144', '0168', '0168-0023', '01', '17.00', 'Xiaomi Mi Wifi Booster(0109)', 'Mr.Makra bring to customer (Dekuvery 2$)', 'TECHNOZOON@gmail.com', '2021-08-05 08:22:34', 'TECHNOZOON@gmail.com', '2021-08-05 08:22:40', NULL, NULL),
('0168-0145', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster (0111)', 'Mr.Bring product to customer', 'TECHNOZOON@gmail.com', '2021-08-12 10:51:12', 'TECHNOZOON@gmail.com', '2021-08-12 10:56:48', NULL, NULL),
('0168-0146', '0168', '0168-0023', '01', '94.00', 'Type-C 11 in 1 (0112)', 'Mr.Makara bring to customer', 'TECHNOZOON@gmail.com', '2021-08-12 10:54:08', 'TECHNOZOON@gmail.com', '2021-08-12 10:56:53', NULL, NULL),
('0168-0147', '0168', '0168-0023', '01', '20.00', 'Razer deathadder essential (0113)', 'Mr.Makara bring to customer', 'TECHNOZOON@gmail.com', '2021-08-12 10:54:46', 'TECHNOZOON@gmail.com', '2021-08-12 10:56:57', NULL, NULL),
('0168-0148', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster (0114)', 'Mr.Makara bring to customer and fix issue', 'TECHNOZOON@gmail.com', '2021-08-12 10:55:42', 'TECHNOZOON@gmail.com', '2021-08-12 10:57:01', NULL, NULL),
('0168-0149', '0168', '0168-0023', '01', '15.00', 'Wireless-N wifi repeater(0115)', NULL, 'TECHNOZOON@gmail.com', '2021-08-12 10:56:37', 'TECHNOZOON@gmail.com', '2021-08-12 10:57:06', NULL, NULL),
('0168-0151', '0168', '0168-0023', '01', '16.00', 'Xiaomi Mi Wifi Booster(0117)', 'Mr.Makara bring to customer (delivery 16$)', 'TECHNOZOON@gmail.com', '2021-08-18 04:26:31', 'TECHNOZOON@gmail.com', '2021-08-18 04:26:38', NULL, NULL),
('0168-0152', '0168', '0168-0023', '01', '30.00', 'Xiaomi Mi Wifi Booster(0116)', 'Mr.Makara bring product to customer', 'TECHNOZOON@gmail.com', '2021-08-18 04:30:47', 'TECHNOZOON@gmail.com', '2021-08-18 04:30:53', NULL, NULL),
('0168-0158', '0168', '0168-0023', '01', '43.00', 'Projector LED Home YG300 (0121)', 'Mr.Makara bring to customer', 'technozoon@gmail.com', '2021-08-21 12:47:31', 'technozoon@gmail.com', '2021-08-21 12:49:28', NULL, NULL),
('0168-0159', '0168', '0168-0023', '01', '35.00', 'Type-C 8 in 1 new Style good box', 'Mr.Makara bring to customer', 'technozoon@gmail.com', '2021-08-21 12:48:47', 'technozoon@gmail.com', '2021-08-21 12:49:34', NULL, NULL),
('0168-0160', '0168', '0168-0023', '01', '13.00', 'Wireless-N wifi repeater (0123)', 'Mr.Makara send to customer province', 'technozoon@gmail.com', '2021-08-21 12:49:24', 'technozoon@gmail.com', '2021-08-21 12:49:38', NULL, NULL),
('0168-0162', '0168', '0168-0023', '01', '13.00', 'Wireless-N wifi repeater(0124)', 'Mr.Makara bring produt to customer', 'technozoon@gmail.com', '2021-08-26 03:05:45', 'technozoon@gmail.com', '2021-08-26 05:06:57', NULL, NULL),
('0168-0163', '0168', '0168-0023', '01', '13.00', 'Wireless-N wifi repeater(0125)', 'Mr.Makara bring to customer', 'technozoon@gmail.com', '2021-08-26 03:06:20', 'technozoon@gmail.com', '2021-08-26 05:07:03', NULL, NULL),
('0168-0164', '0168', '0168-0023', '01', '17.00', 'Razer deathadder essential(0126)', 'Mr.Makara bring product to customer', 'technozoon@gmail.com', '2021-08-26 03:07:13', 'technozoon@gmail.com', '2021-08-26 05:07:09', NULL, NULL),
('0168-0165', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0127)', NULL, 'technozoon@gmail.com', '2021-08-27 13:55:18', 'technozoon@gmail.com', '2021-08-27 13:55:46', NULL, NULL),
('0168-0166', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster (0128)', NULL, 'technozoon@gmail.com', '2021-08-27 13:55:40', 'technozoon@gmail.com', '2021-08-27 13:55:50', NULL, NULL),
('0168-0168', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0129)', '', 'technozoon@gmail.com', '2021-08-31 06:36:32', 'technozoon@gmail.com', '2021-08-31 06:41:37', NULL, NULL),
('0168-0169', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0130)', '', 'technozoon@gmail.com', '2021-08-31 06:37:54', 'technozoon@gmail.com', '2021-08-31 06:41:42', NULL, NULL),
('0168-0170', '0168', '0168-0023', '01', '13.00', 'Wireless-N wifi repeater(0131)', '', 'technozoon@gmail.com', '2021-08-31 06:38:35', 'technozoon@gmail.com', '2021-08-31 06:41:49', NULL, NULL),
('0168-0171', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0132)', '', 'technozoon@gmail.com', '2021-08-31 06:40:07', 'technozoon@gmail.com', '2021-08-31 06:41:54', NULL, NULL),
('0168-0172', '0168', '0168-0023', '01', '49.00', 'Type-C 11 in 1(0134)', '', 'technozoon@gmail.com', '2021-08-31 06:40:57', 'technozoon@gmail.com', '2021-08-31 06:42:02', NULL, NULL),
('0168-0173', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0135)', '', 'technozoon@gmail.com', '2021-08-31 06:41:31', 'technozoon@gmail.com', '2021-08-31 06:42:07', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_invoices`
--

CREATE TABLE `pos_tbl_invoices` (
  `inv_num` varchar(20) NOT NULL,
  `cus_id` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `inv_date` datetime DEFAULT NULL,
  `inv_reason` varchar(250) DEFAULT NULL,
  `inv_exchange` decimal(13,2) DEFAULT NULL,
  `inv_referent` varchar(50) DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_invoice_return`
--

CREATE TABLE `pos_tbl_invoice_return` (
  `inv_num` varchar(20) NOT NULL,
  `cus_id` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `inv_date` datetime DEFAULT NULL,
  `inv_reason` varchar(250) DEFAULT NULL,
  `inv_exchange` decimal(13,2) DEFAULT NULL,
  `inv_referent` varchar(50) DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_invoice_return`
--

INSERT INTO `pos_tbl_invoice_return` (`inv_num`, `cus_id`, `branchcode`, `inv_date`, `inv_reason`, `inv_exchange`, `inv_referent`, `sys_token`, `inputter`, `inputdate`, `authorizer`, `auth_date`) VALUES
('0055', '0038', '0168', '2021-05-24 14:38:34', 'Wrong booking product name', '4100.00', '0045', '0168-60abba6a49a19', 'TECHNOZOON@gmail.com', '2021-05-24 14:38:34', 'TECHNOZOON@gmail.com', '2021-05-24 14:38:38'),
('0056', '0032', '0168', '2021-05-24 14:40:22', 'Customer cancel product at Takmao', '4100.00', '0038', '0168-60abbad6a5262', 'TECHNOZOON@gmail.com', '2021-05-24 14:40:22', 'TECHNOZOON@gmail.com', '2021-05-24 14:40:27'),
('0057', '0041', '0168', '2021-05-24 14:41:24', 'Double booking 095888360', '4100.00', '0048', '0168-60abbb14b6d82', 'TECHNOZOON@gmail.com', '2021-05-24 14:41:24', 'TECHNOZOON@gmail.com', '2021-05-24 14:41:29'),
('0067', '0049', '0168', '2021-05-31 06:55:25', 'Wrong booking product Invoice : 0061', '4100.00', '0061', '0168-60b4885dd7812', 'TECHNOZOON@gmail.com', '2021-05-31 06:55:25', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:20'),
('0068', '0050', '0168', '2021-05-31 07:06:47', 'Wrong price sell : 0062', '4100.00', '0062', '0168-60b48b07c12c6', 'TECHNOZOON@gmail.com', '2021-05-31 07:06:47', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:32'),
('0069', '0051', '0168', '2021-05-31 07:07:45', 'Wrong booking duplicate', '4100.00', '0063', '0168-60b48b417267a', 'TECHNOZOON@gmail.com', '2021-05-31 07:07:45', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:28'),
('0070', '0052', '0168', '2021-05-31 07:08:14', 'Booking duplicate', '4100.00', '0064', '0168-60b48b5ebe124', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:14', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:24'),
('0071', '0044', '0168', '2021-05-31 09:16:47', 'Customer need to change new item 10 in 1', '4100.00', '0051', '0168-60b4a97f0bf0c', 'TECHNOZOON@gmail.com', '2021-05-31 09:16:47', 'TECHNOZOON@gmail.com', '2021-05-31 09:16:52');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_line`
--

CREATE TABLE `pos_tbl_line` (
  `line_id` varchar(10) NOT NULL,
  `line_name` varchar(50) DEFAULT NULL,
  `line_type` varchar(10) DEFAULT NULL,
  `inactive` int(11) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_line`
--

INSERT INTO `pos_tbl_line` (`line_id`, `line_name`, `line_type`, `inactive`, `inputter`) VALUES
('01', 'Gender', NULL, 1, 'IT.SYSTEM'),
('02', 'Stock', NULL, 0, 'IT.SYSTEM'),
('03', 'Product line', NULL, 0, 'IT.SYSTEM'),
('04', 'Product Type', NULL, 0, 'IT.SYSTEM'),
('05', 'Transfer line', NULL, 0, 'IT.SYSTEM'),
('07', 'Supply line', NULL, 0, 'IT.SYSTEM'),
('08', 'Income', NULL, 0, 'IT.SYSTEM'),
('09', 'Expense', NULL, 0, 'IT.SYSTEM');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_payment_method`
--

CREATE TABLE `pos_tbl_payment_method` (
  `pay_id` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `pay_name` varchar(250) DEFAULT NULL,
  `pay_account` varchar(50) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_products`
--

CREATE TABLE `pos_tbl_products` (
  `pro_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `barcode` varchar(20) NOT NULL,
  `pro_type` varchar(10) DEFAULT NULL,
  `pro_line` varchar(10) DEFAULT NULL,
  `pro_name` varchar(250) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pro_inactive` int(11) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_products`
--

INSERT INTO `pos_tbl_products` (`pro_id`, `branchcode`, `barcode`, `pro_type`, `pro_line`, `pro_name`, `pro_cost`, `pro_up`, `pro_discount`, `pro_inactive`, `remark`, `inputter`, `inputdate`) VALUES
('0001-0001', '0001', 'T0001', '0001-0007', '0001-0005', 'logitech G102', '16.00', '20.00', '0.00', 0, NULL, 'bongmap@gmail.com', '2021-03-27 16:29:24'),
('0001-0002', '0001', 'T0002', '0001-0008', '0001-0005', 'Monitor MSI 27inc', '150.00', '170.00', '0.00', 0, NULL, 'bongmap@gmail.com', '2021-03-27 16:30:16'),
('0004-0001', '0004', 'A0001', '0004-0010', '0004-0006', 'Logitech-G102', '15.00', '21.50', '0.00', 0, 'Best product for Sale in 2021', 'technodemo@gmail.com', '2021-03-29 14:56:20'),
('0004-0002', '0004', 'A0002', '0004-0009', '0004-0006', 'Monitor MSI 27 inch', '155.00', '165.00', '0.00', 0, NULL, 'technodemo@gmail.com', '2021-03-29 14:57:49'),
('0004-0003', '0004', 'A0003', '0004-0008', '0004-0006', 'Razer 1100', '14.50', '17.50', '0.00', 0, NULL, 'technodemo@gmail.com', '2021-03-29 14:58:55'),
('0004-0004', '0004', 'A0010', '0004-0008', '0004-0006', 'type-c connector', '5.00', '15.00', '5.00', 0, NULL, 'technodemo@gmail.com', '2021-03-30 09:14:31'),
('0004-0005', '0004', '00001', '0004-0008', '0004-0006', 'Monitor MSI 27inc', '2.00', '3.00', '0.00', 0, NULL, 'technodemo@gmail.com', '2021-04-09 06:07:53'),
('0027-0005', '0027', 'A0001', '0027-0013', '0027-0006', 'Key board G201', '3.00', '4.50', '0.00', 0, NULL, 'bongmap@gmail.com', '2021-03-04 22:04:07'),
('0027-0006', '0027', '00001', '0027-0013', '0027-0004', 'Iphone 8', '350.00', '450.00', '0.00', 0, NULL, 'bongmap@gmail.com', '2021-03-04 22:24:24'),
('0027-0016', '0027', '00001111', '0027-0013', '0027-0004', 'Monitor Dell 24inc', '355.00', '370.00', '0.00', 0, 's', 'bongmap@gmail.com', '2021-03-20 16:45:16'),
('0027-0017', '0027', '00666', '0027-0013', '0027-0004', 'Iphone 8 plus', '300.00', '4900.00', '5.00', 0, NULL, 'bongmap@gmail.com', '2021-03-21 18:31:46'),
('0027-0018', '0027', 'msi0001', '0027-0022', '0027-0006', 'Monitor MSI 27inc', '450.00', '470.00', '0.00', 0, NULL, 'bongmap@gmail.com', '2021-03-25 13:43:36'),
('0027-0019', '0027', 'msi0002', '0027-0013', '0027-0006', 'logitech G102', '20.00', '22.00', '5.00', 0, NULL, 'bongmap@gmail.com', '2021-03-25 13:46:22'),
('0167-0001', '0167', '0002', '0167-0007', '0167-0008', 'G102', '20.00', '22.00', '0.00', 0, NULL, 'demopos@gmail.com', '2021-03-24 19:06:14'),
('0168-0001', '0168', 'A0001', '0168-0010', '0168-0005', 'logitech G102', '15.00', '19.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:00:38'),
('0168-0002', '0168', 'A0002', '0168-0009', '0168-0005', 'Redragon (M19)', '21.00', '25.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:04:47'),
('0168-0003', '0168', 'A0003', '0168-0009', '0168-0005', 'Aula F2016', '24.00', '27.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:07:30'),
('0168-0004', '0168', 'A0004', '0168-0009', '0168-0005', 'Aula F2058', '27.00', '30.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:08:06'),
('0168-0005', '0168', 'A0005', '0168-0015', '0168-0005', 'SSD WD 240GB', '28.50', '35.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:13:28'),
('0168-0006', '0168', 'A0006', '0168-0015', '0168-0005', 'SSD King stone 240GB', '28.50', '35.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:14:14'),
('0168-0007', '0168', 'A0007', '0168-0015', '0168-0005', 'SSD Memo boss 256G', '28.00', '35.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:15:11'),
('0168-0008', '0168', 'B0001', '0168-0010', '0168-0005', 'Rapoo V22', '12.50', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:26:44'),
('0168-0009', '0168', 'B0002', '0168-0010', '0168-0005', 'Rapoo V16', '12.50', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:28:25'),
('0168-0010', '0168', 'B0003', '0168-0010', '0168-0005', 'Razer deathadder essential', '20.00', '19.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:30:55'),
('0168-0011', '0168', 'B0004', '0168-0010', '0168-0005', 'HP Gaming Mouse M280', '12.50', '22.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:32:56'),
('0168-0012', '0168', 'B0005', '0168-0009', '0168-0005', 'HP Gaming Keyboard K10G', '25.00', '28.00', '0.00', 0, 'Free Mousepad', 'bongratha@gmail.com', '2021-03-31 08:36:23'),
('0168-0013', '0168', 'B0006', '0168-0013', '0168-0005', 'Type-C HDMI single HDMI', '12.50', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:40:17'),
('0168-0014', '0168', 'B0007', '0168-0013', '0168-0005', 'HDMI Bi-Direction Switch', '6.50', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:42:23'),
('0168-0015', '0168', 'B0008', '0168-0016', '0168-0005', 'Wood table - lamp modern', '7.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 08:47:58'),
('0168-0016', '0168', 'B0009', '0168-0017', '0168-0005', 'Aluminum Laptop Stand for Desk Compatible with Mac MacBook', '26.50', '33.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-03-31 09:17:31'),
('0168-0017', '0168', 'B0010', '0168-0015', '0168-0005', 'Wrong name SSD', '26.41', '37.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-04-07 10:35:40'),
('0168-0018', '0168', 'B00011', '0168-0026', '0168-0005', 'TV MXQ PRO MXQ-4K set top box 1GB+2GB/8GB+16GB', '18.00', '37.00', '0.00', 0, 'MXQ PRO MXQ-4K set top box 1GB+2GB/8GB+16GB', 'TECHNOZOON@gmail.com', '2021-04-07 13:57:19'),
('0168-0019', '0168', 'B0012', '0168-0013', '0168-0005', 'Type-C 6 in1 HDMI', '8.50', '19.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-04-09 10:54:33'),
('0168-0020', '0168', 'b00012', '0168-0017', '0168-0005', 'Fenyr Supper Toy Car', '8.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-04-13 02:01:41'),
('0168-0021', '0168', 'B0013', '0168-0017', '0168-0005', 'AMG G-Class G63 Toy Car', '8.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-04-13 06:39:51'),
('0168-0022', '0168', 'B0014', '0168-0032', '0168-0005', 'Projector LED Home YG300 -1080P', '21.00', '47.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-04-28 02:37:52'),
('0168-0023', '0168', 'B0015', '0168-0032', '0168-0005', 'Projector X20  LCD home theater toy', '27.00', '57.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-04-28 02:40:52'),
('0168-0024', '0168', 'B0016', '0168-0033', '0168-0005', 'Xiaomi Mi Wifi Booster', '8.50', '15.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-04-28 03:13:02'),
('0168-0025', '0168', 'B0017', '0168-0033', '0168-0005', 'Wifi Adapter USB Ralink RT5370 Main Chip', '4.00', '10.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-04-28 03:14:29'),
('0168-0026', '0168', 'B0018', '0168-0033', '0168-0005', 'Wifi repeater wireless-n 802.11 KP300', '7.50', '20.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-04-28 03:15:32'),
('0168-0027', '0168', 'B0019', '0168-0034', '0168-0005', 'Delete because of double', '50.00', '65.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-05-09 14:57:48'),
('0168-0028', '0168', 'B0020', '0168-0035', '0168-0005', 'double  Podcasting', '31.00', '45.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-05-09 14:58:47'),
('0168-0029', '0168', '0033', '0168-0013', '0168-0005', 'Type-C 11 in 1', '27.00', '49.00', '0.00', 0, NULL, 'Sale@gmail.com', '2021-05-13 05:32:06'),
('0168-0030', '0168', 'B0021', '0168-0013', '0168-0005', 'Type-C 10 in 1  USB-C HUB Adapter', '19.00', '35.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-05-13 05:47:27'),
('0168-0031', '0168', '0034', '0168-0033', '0168-0005', 'Mi repeater pro wifi', '9.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 06:31:53'),
('0168-0032', '0168', '0035', '0168-0033', '0168-0005', 'Wireless-N wifi repeater', '7.00', '15.00', '0.00', 1, NULL, 'bongratha@gmail.com', '2021-05-13 06:33:54'),
('0168-0033', '0168', '0036', '0168-0033', '0168-0005', 'Wireless USB Adapter', '6.00', '12.00', '0.00', 1, NULL, 'bongratha@gmail.com', '2021-05-13 06:35:11'),
('0168-0034', '0168', '0037', '0168-0013', '0168-0005', 'Type-C 8 in 1', '19.00', '33.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 06:38:27'),
('0168-0035', '0168', '0038', '0168-0013', '0168-0005', 'Type-C 10 in 1', '19.00', '39.00', '0.00', 1, NULL, 'bongratha@gmail.com', '2021-05-13 06:39:32'),
('0168-0036', '0168', '0039', '0168-0034', '0168-0005', 'Maono AU-902 Cardioid Microphone', '32.00', '55.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 06:43:40'),
('0168-0037', '0168', '0040', '0168-0012', '0168-0005', 'MAONO AU-AM200 CASTER', '50.00', '85.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 06:45:07'),
('0168-0038', '0168', '0041', '0168-0013', '0168-0005', 'HDMI/F USB-C', '9.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 07:56:21'),
('0168-0039', '0168', '0042', '0168-0013', '0168-0005', 'HDMI Bi-Direction Switch', '9.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 07:58:02'),
('0168-0040', '0168', '0043', '0168-0013', '0168-0005', 'Type-c USB Onten', '9.00', '15.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 07:59:59'),
('0168-0041', '0168', '0044', '0168-0017', '0168-0005', 'Aluminum Laptop Stand for Desk Compatible with Mac MacBook', '24.00', '33.00', '0.00', 0, NULL, 'bongratha@gmail.com', '2021-05-13 08:03:41'),
('0168-0042', '0168', 'B0045', '0168-0032', '0168-0005', 'Projector YG320', '27.00', '65.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-05-22 00:53:16'),
('0168-0043', '0168', 'B0046', '0168-0013', '0168-0005', 'Type-C 8 in 1 new Style good box', '21.50', '35.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-07-20 06:22:48'),
('0168-0044', '0168', 'B00047', '0168-0017', '0168-0005', 'Lamps Powered Monitor USB', '14.00', '25.00', '0.00', 0, NULL, 'TECHNOZOON@gmail.com', '2021-07-31 02:44:54'),
('0168-0045', '0168', 'B0048', '0168-0012', '0168-0005', 'KS06 HIFI Gaming', '9.00', '17.00', '0.00', 0, NULL, 'sale@gmail.com', '2021-09-03 23:46:11'),
('0168-0046', '0168', 'B0049', '0168-0017', '0168-0005', 'Memo DL05', '3.00', '15.00', '0.00', 0, NULL, 'sale@gmail.com', '2021-09-03 23:51:25'),
('0168-0047', '0168', 'B0050', '0168-0017', '0168-0005', 'Memo DL01', '10.00', '13.00', '0.00', 0, NULL, 'sale@gmail.com', '2021-09-03 23:52:16'),
('0168-0048', '0168', 'B0051', '0168-0017', '0168-0005', 'Apai Genie 2', '4.00', '22.00', '0.00', 0, NULL, 'sale@gmail.com', '2021-09-03 23:53:53');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_proline`
--

CREATE TABLE `pos_tbl_proline` (
  `line_id` varchar(10) NOT NULL,
  `branchcode` varchar(45) NOT NULL,
  `line_name` varchar(150) DEFAULT NULL,
  `line_type` varchar(10) DEFAULT NULL,
  `inactive` varchar(10) DEFAULT NULL,
  `line_remark` varchar(255) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `store_id` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_proline`
--

INSERT INTO `pos_tbl_proline` (`line_id`, `branchcode`, `line_name`, `line_type`, `inactive`, `line_remark`, `inputter`, `inputdate`, `store_id`) VALUES
('0001-0001', '0001', 'Main stock', '02', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:26:08', NULL),
('0001-0002', '0001', 'Sale stock', '02', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:26:29', NULL),
('0001-0003', '0001', 'Male', '01', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:26:53', NULL),
('0001-0004', '0001', 'Female', '01', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:27:02', NULL),
('0001-0005', '0001', 'Harward', '03', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:27:17', NULL),
('0001-0006', '0001', 'Software', '03', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:27:31', NULL),
('0001-0007', '0001', 'Mouse', '04', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:27:45', NULL),
('0001-0008', '0001', 'Keyboard', '04', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:27:55', NULL),
('0001-0009', '0001', 'VIP', '05', '0', NULL, 'bongmap@gmail.com', '2021-03-27 16:28:12', NULL),
('0001-0010', '0001', 'G-Supplier', '07', '0', NULL, 'bongmap@gmail.com', '2021-03-28 10:18:36', NULL),
('0001-0011', '0001', 'VIP', '07', '0', NULL, 'bongmap@gmail.com', '2021-03-28 10:18:46', NULL),
('0004-0001', '0004', 'Male', '01', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:49:21', NULL),
('0004-0002', '0004', 'Female', '01', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:49:34', NULL),
('0004-0003', '0004', 'Stock Main', '02', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:49:54', NULL),
('0004-0004', '0004', 'Stock Sale', '02', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:50:08', NULL),
('0004-0005', '0004', 'Stock Return', '02', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:50:28', NULL),
('0004-0006', '0004', 'Hardward', '03', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:50:45', NULL),
('0004-0007', '0004', 'Software', '03', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:50:57', NULL),
('0004-0008', '0004', 'Keyboard', '04', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:51:12', NULL),
('0004-0009', '0004', 'Monitor', '04', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:51:27', NULL),
('0004-0010', '0004', 'Mouse', '04', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:51:48', NULL),
('0004-0011', '0004', 'General', '07', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:52:04', NULL),
('0004-0012', '0004', 'Best Support', '07', '0', NULL, 'technodemo@gmail.com', '2021-03-29 14:52:21', NULL),
('0004-0013', '0004', '213', '02', '0', NULL, 'technodemo@gmail.com', '2021-04-09 06:11:22', NULL),
('0027-0001', '0027', 'Male', '01', '0', 'Remark', 'bongmap@gmail.com', '2021-03-20 13:53:56', NULL),
('0027-0003', '0027', 'Female', '01', '0', NULL, 'bongmap@gmail.com', '2021-03-14 19:52:32', NULL),
('0027-0004', '0027', 'Software', '03', '0', NULL, 'bongmap@gmail.com', '2021-03-25 13:42:47', NULL),
('0027-0006', '0027', 'Harward', '03', '0', NULL, 'bongmap@gmail.com', '2021-03-25 13:42:56', NULL),
('0027-0013', '0027', 'Box', '04', '0', NULL, 'bongmap@gmail.com', '2021-03-04 09:52:02', NULL),
('0027-0015', '0027', 'Cost', '05', '0', NULL, 'bongmap@gmail.com', '2021-02-27 15:24:42', NULL),
('0027-0016', '0027', 'VIP', '07', '0', NULL, 'bongmap@gmail.com', '2021-02-27 15:24:26', NULL),
('0027-0017', '0027', 'G-Supplier', '07', '0', NULL, 'bongmap@gmail.com', '2021-02-28 10:03:48', NULL),
('0027-0018', '0027', 'Water', '04', '1', NULL, 'bongmap@gmail.com', '2021-03-25 14:00:46', NULL),
('0027-0019', '0027', 'Stock expired', '02', '0', NULL, 'bongmap@gmail.com', '2021-03-20 11:46:35', NULL),
('0027-0020', '0027', 'Stock Sale', '02', '0', NULL, 'bongmap@gmail.com', '2021-03-23 22:26:35', NULL),
('0027-0021', '0027', 'Stock main', '02', '0', NULL, 'bongmap@gmail.com', '2021-03-20 11:45:58', NULL),
('0027-0022', '0027', 'Monitor', '04', '0', NULL, 'bongmap@gmail.com', '2021-03-25 13:42:34', NULL),
('0167-0001', '0167', 'Male', '01', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:02:32', NULL),
('0167-0002', '0167', 'Female', '01', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:02:47', NULL),
('0167-0003', '0167', 'Main stock', '02', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:03:04', NULL),
('0167-0004', '0167', 'Sale stock', '02', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:03:23', NULL),
('0167-0005', '0167', 'Box', '03', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:03:33', NULL),
('0167-0006', '0167', 'Keyboard', '04', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:04:14', NULL),
('0167-0007', '0167', 'Mouse', '04', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:04:06', NULL),
('0167-0008', '0167', 'Harward', '03', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:04:26', NULL),
('0167-0009', '0167', 'Software', '03', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:04:37', NULL),
('0167-0010', '0167', 'Genneral', '07', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:04:53', NULL),
('0167-0011', '0167', 'VIP', '07', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:05:06', NULL),
('0168-0001', '0168', 'Male', '01', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-29 12:57:07', NULL),
('0168-0002', '0168', 'Female', '01', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-29 12:57:32', NULL),
('0168-0003', '0168', 'Main stocks', '02', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-29 12:57:54', NULL),
('0168-0004', '0168', 'Sale stock', '02', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-17 06:42:13', NULL),
('0168-0005', '0168', 'Hardware', '03', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-29 13:00:08', NULL),
('0168-0006', '0168', 'Software', '03', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-17 06:43:13', NULL),
('0168-0007', '0168', 'Service', '03', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-29 13:00:39', NULL),
('0168-0008', '0168', 'Return stock', '02', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-29 13:01:43', NULL),
('0168-0009', '0168', 'Keyboard', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-30 09:48:11', NULL),
('0168-0010', '0168', 'Mouse', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-30 09:48:21', NULL),
('0168-0011', '0168', 'Mornitor', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-30 13:32:06', NULL),
('0168-0012', '0168', 'Speaker', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-30 13:32:30', NULL),
('0168-0013', '0168', 'Type-C Connector', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-09 09:01:31', NULL),
('0168-0014', '0168', 'Hard disk', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:10:18', NULL),
('0168-0015', '0168', 'SDD', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-31 00:11:59', NULL),
('0168-0016', '0168', 'Lamp', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-31 09:19:44', NULL),
('0168-0017', '0168', 'Other', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-03-31 09:20:06', NULL),
('0168-0018', '0168', 'Fixed assets', '02', '1', NULL, 'TECHNOZOON@gmail.com', '2021-04-09 09:07:30', NULL),
('0168-0019', '0168', 'Other Income', '08', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-01 07:19:07', NULL),
('0168-0020', '0168', 'Other expense', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-01 07:19:25', NULL),
('0168-0021', '0168', 'Genneral', '07', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 09:24:58', NULL),
('0168-0022', '0168', 'Best support', '07', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 09:25:13', NULL),
('0168-0023', '0168', 'Sold Out', '08', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 13:23:54', NULL),
('0168-0024', '0168', 'Shipping', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 13:24:12', NULL),
('0168-0025', '0168', 'Buy product online Alibaba', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-09 02:52:42', NULL),
('0168-0026', '0168', 'TV-Box', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-07 13:51:45', NULL),
('0168-0027', '0168', 'Buy product online Taobao', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-09 02:53:21', NULL),
('0168-0028', '0168', 'Buy product online Aliexpress', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-09 02:53:38', NULL),
('0168-0029', '0168', 'Facebook Boost', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-09 02:58:34', NULL),
('0168-0030', '0168', 'Salary', '09', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-24 08:00:04', NULL),
('0168-0031', '0168', 'N/A', '03', '1', NULL, 'technozoon@gmail.com', '2021-08-25 06:57:55', NULL),
('0168-0032', '0168', 'Slide Projector', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-05-09 14:54:28', NULL),
('0168-0033', '0168', 'Wifi repeater', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-05-09 14:59:38', NULL),
('0168-0034', '0168', 'Podcasting', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-05-09 14:59:52', NULL),
('0168-0035', '0168', 'Microphone', '04', '0', NULL, 'TECHNOZOON@gmail.com', '2021-05-09 15:00:07', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_pro_type`
--

CREATE TABLE `pos_tbl_pro_type` (
  `typ_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `typ_name` varchar(100) DEFAULT NULL,
  `typ_flag` int(11) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_purchase_details`
--

CREATE TABLE `pos_tbl_purchase_details` (
  `sysdonum` varchar(10) NOT NULL,
  `pur_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `barcode` varchar(10) DEFAULT NULL,
  `stockcode` varchar(10) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_qty` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pur_amount` decimal(13,2) DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `pur_remark` varchar(250) DEFAULT NULL,
  `pur_exchange` decimal(13,2) DEFAULT NULL,
  `pro_expired` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_purchase_details`
--

INSERT INTO `pos_tbl_purchase_details` (`sysdonum`, `pur_id`, `branchcode`, `pro_code`, `barcode`, `stockcode`, `pro_cost`, `pro_up`, `pro_qty`, `pro_discount`, `pur_amount`, `currency`, `pur_remark`, `pur_exchange`, `pro_expired`) VALUES
('0001', '0001', '0001', '0001-0001', 'T0001', '0001-0001', '2.00', NULL, '10.00', '10.00', '18.00', '01', '', NULL, NULL),
('0001', '0001', '0004', '0004-0001', 'A0001', '0004-0003', '13.00', NULL, '3.00', '10.00', '35.10', '01', '', NULL, NULL),
('0001', '0001', '0167', '0167-0001', '0002', '0167-0003', '15.00', NULL, '10.00', '0.00', '150.00', '01', '', NULL, NULL),
('0001', '0001', '0168', '0168-0001', 'A0001', '0168-0004', '16.00', NULL, '3.00', '0.00', '48.00', '01', '', NULL, NULL),
('0002', '0001', '0004', '0004-0002', 'A0002', '0004-0003', '145.00', NULL, '1.00', '0.00', '145.00', '01', '', NULL, NULL),
('0002', '0002', '0001', '0001-0002', 'T0002', '0001-0001', '250.00', NULL, '100.00', '10.00', '22500.00', '01', '', NULL, NULL),
('0002', '0002', '0168', '0168-0019', 'B0012', '0168-0004', '8.50', NULL, '5.00', '0.00', '42.50', '01', '', NULL, NULL),
('0003', '0002', '0001', '0001-0001', 'T0001', '0001-0001', '22.00', NULL, '15.00', '0.00', '330.00', '01', '', NULL, NULL),
('0003', '0002', '0004', '0004-0002', 'A0002', '0004-0003', '145.00', NULL, '1.00', '0.00', '145.00', '01', '', NULL, NULL),
('0003', '0002', '0168', '0168-0010', 'B0003', '0168-0004', '15.00', NULL, '5.00', '0.00', '75.00', '01', '', NULL, NULL),
('0004', '0003', '0004', '0004-0004', 'A0010', '0004-0003', '4.00', NULL, '10.00', '10.00', '36.00', '01', '', NULL, NULL),
('0004', '0003', '0168', '0168-0021', 'B0013', '0168-0004', '8.00', NULL, '9.00', '0.00', '72.00', '01', '', NULL, NULL),
('0005', '0003', '0004', '0004-0001', 'A0001', '0004-0003', '16.00', NULL, '5.00', '0.00', '80.00', '01', '', NULL, NULL),
('0005', '0003', '0168', '0168-0020', 'b00012', '0168-0004', '8.00', NULL, '1.00', '0.00', '8.00', '01', '', NULL, NULL),
('0006', '0004', '0004', '0004-0001', 'A0001', '0004-0003', '15.00', NULL, '15.00', '0.00', '225.00', '01', '', NULL, NULL),
('0006', '0004', '0168', '0168-0022', 'B0014', '0168-0004', '21.00', NULL, '3.00', '0.00', '63.00', '01', '', NULL, NULL),
('0007', '0004', '0004', '0004-0004', 'A0010', '0004-0003', '5.00', NULL, '6.00', '0.00', '30.00', '01', '', NULL, NULL),
('0007', '0004', '0168', '0168-0023', 'B0015', '0168-0004', '27.00', NULL, '2.00', '0.00', '54.00', '01', '', NULL, NULL),
('0008', '0005', '0168', '0168-0024', 'B0016', '0168-0004', '8.50', NULL, '10.00', '0.00', '85.00', '01', '', NULL, NULL),
('0009', '0005', '0168', '0168-0025', 'B0017', '0168-0004', '3.50', NULL, '10.00', '0.00', '35.00', '01', '', NULL, NULL),
('0010', '0005', '0168', '0168-0026', 'B0018', '0168-0004', '7.50', NULL, '10.00', '0.00', '75.00', '01', '', NULL, NULL),
('0011', '0006', '0168', '0168-0027', 'B0019', '0168-0004', '51.00', NULL, '3.00', '0.00', '153.00', '01', '', NULL, NULL),
('0012', '0006', '0168', '0168-0028', 'B0020', '0168-0004', '31.00', NULL, '3.00', '0.00', '93.00', '01', '', NULL, NULL),
('0013', '0007', '0168', '0168-0030', 'B0021', '0168-0004', '19.00', NULL, '5.00', '0.00', '95.00', '01', '', NULL, NULL),
('0014', '0008', '0168', '0168-0022', 'B0014', '0168-0004', '21.00', NULL, '3.00', '0.00', '63.00', '01', '', NULL, NULL),
('0015', '0008', '0168', '0168-0023', 'B0015', '0168-0004', '27.00', NULL, '2.00', '0.00', '54.00', '01', '', NULL, NULL),
('0016', '0008', '0168', '0168-0042', 'B0045', '0168-0004', '27.00', NULL, '3.00', '0.00', '81.00', '01', '', NULL, NULL),
('0017', '0009', '0168', '0168-0024', 'B0016', '0168-0004', '8.65', NULL, '10.00', '0.00', '86.50', '01', '', NULL, NULL),
('0018', '0009', '0168', '0168-0025', 'B0017', '0168-0004', '3.35', NULL, '10.00', '0.00', '33.50', '01', '', NULL, NULL),
('0019', '0010', '0168', '0168-0043', 'B0046', '0168-0004', '21.50', NULL, '10.00', '0.00', '215.00', '01', '', NULL, NULL),
('0020', '0011', '0168', '0168-0030', 'B0021', '0168-0004', '18.50', NULL, '10.00', '0.00', '185.00', '01', '', NULL, NULL),
('0021', '0011', '0168', '0168-0029', '0033', '0168-0004', '27.50', NULL, '3.00', '0.00', '82.50', '01', '', NULL, NULL),
('0022', '0012', '0168', '0168-0024', 'B0016', '0168-0004', '8.10', NULL, '20.00', '0.00', '162.00', '01', '', NULL, NULL),
('0027-0043', '0027-0043', '0027', '0027-0009', 'B0001', NULL, '2.00', NULL, '3.00', '10.00', '5.40', '01', '', NULL, NULL),
('0027-0044', '0027-0043', '0027', '0027-0005', 'A0001', NULL, '2.00', NULL, '4.00', '20.00', '6.40', '01', '', NULL, NULL),
('0027-0062', '0027-0055', '0027', '0027-0009', 'B0001', NULL, '2.00', NULL, '2.00', '2.00', '3.92', '01', '', NULL, NULL),
('0027-0063', '0027-0055', '0027', '0027-0005', 'A0001', NULL, '2.00', NULL, '2.00', '2.00', '3.92', '01', '', NULL, NULL),
('0027-0071', '0027-0062', '0027', '0027-0009', 'B0001', '0027-0019', '1.00', NULL, '1.00', '10.00', '0.90', '01', '', NULL, NULL),
('0027-0072', '0027-0062', '0027', '0027-0005', 'A0001', '0027-0020', '1.00', NULL, '2.00', '2.00', '1.96', '01', '', NULL, NULL),
('0073', '0063', '0027', '0027-0009', 'B0001', '0027-0020', '1.00', NULL, '1.00', '2.00', '0.98', '01', '', NULL, NULL),
('0074', '0063', '0027', '0027-0005', 'A0001', '0027-0019', '1.00', NULL, '1.00', '2.00', '0.98', '01', '', NULL, NULL),
('0075', '0064', '0027', '0027-0009', 'B0001', '0027-0019', '1.00', NULL, '2.00', '10.00', '1.80', '01', '', NULL, NULL),
('0076', '0064', '0027', '0027-0005', 'A0001', '0027-0020', '1.00', NULL, '2.00', '10.00', '1.80', '01', '', NULL, NULL),
('0077', '0065', '0027', '0027-0009', 'B0001', '0027-0019', '2.00', NULL, '2.00', '10.00', '3.60', '01', '', NULL, NULL),
('0089', '0074', '0027', '0027-0009', 'B0001', '0027-0019', '1.00', NULL, '2.00', '0.00', '2.00', '01', '', NULL, NULL),
('0090', '0074', '0027', '0027-0005', 'A0001', '0027-0020', '1.00', NULL, '1.00', '0.00', '1.00', '01', '', NULL, NULL),
('0091', '0075', '0027', '0027-0009', 'B0001', '0027-0019', '1.00', NULL, '1.00', '0.00', '1.00', '01', '', NULL, NULL),
('0092', '0075', '0027', '0027-0005', 'A0001', '0027-0020', '1.00', NULL, '1.00', '10.00', '0.90', '01', '', NULL, NULL),
('0093', '0076', '0027', '0027-0009', 'B0001', '0027-0019', '1.00', NULL, '2.00', '0.00', '2.00', '01', '', NULL, NULL),
('0094', '0076', '0027', '0027-0005', 'A0001', '0027-0020', '1.00', NULL, '1.00', '0.00', '1.00', '01', '', NULL, NULL),
('0095', '0077', '0027', '0027-0005', 'A0001', '0027-0020', '10.00', NULL, '102.00', '0.00', '1020.00', '01', '', NULL, NULL),
('0096', '0077', '0027', '0027-0009', 'B0001', '0027-0020', '1.00', NULL, '10.00', '55.00', '4.50', '01', '', NULL, NULL),
('0097', '0078', '0027', '0027-0009', 'B0001', '0027-0019', '3.00', NULL, '3.00', '0.00', '9.00', '01', '', NULL, NULL),
('0098', '0078', '0027', '0027-0005', 'A0001', '0027-0019', '2.00', NULL, '102.00', '0.00', '204.00', '01', '', NULL, NULL),
('0099', '0079', '0027', '0027-0005', 'A0001', '0027-0020', '2.20', NULL, '101.00', '0.00', '222.20', '01', '', NULL, NULL),
('0100', '0079', '0027', '0027-0009', 'B0001', '0027-0020', '2.30', NULL, '106.00', '0.00', '243.80', '01', '', NULL, NULL),
('0101', '0080', '0027', '0027-0009', 'B0001', '0027-0019', '1.50', NULL, '508.00', '0.00', '762.00', '01', '', NULL, NULL),
('0102', '0080', '0027', '0027-0005', 'A0001', '0027-0019', '1.60', NULL, '502.00', '0.00', '803.20', '01', '', NULL, NULL),
('0103', '0080', '0027', '0027-0009', 'B0001', '0027-0019', '1.30', NULL, '707.00', '0.00', '919.10', '01', '', NULL, NULL),
('0104', '0081', '0027', '0027-0009', 'B0001', '0027-0021', '10.30', NULL, '103.00', '0.00', '1060.90', '01', '', NULL, NULL),
('0105', '0082', '0027', '0027-0009', 'B0001', '0027-0021', '10.66', NULL, '203.00', '0.00', '2163.98', '01', '', NULL, NULL),
('0106', '0083', '0027', '0027-0009', 'B0001', '0027-0021', '1.55', NULL, '66.00', '0.00', '102.30', '01', '', NULL, NULL),
('0107', '0084', '0027', '0027-0009', 'B0001', '0027-0021', '5.55', NULL, '155.00', '0.00', '860.25', '01', '', NULL, NULL),
('0108', '0085', '0027', '0027-0005', 'A0001', '0027-0021', '1.44', NULL, '109.00', '0.00', '156.96', '01', '', NULL, NULL),
('0109', '0086', '0027', '0027-0009', 'B0001', '0027-0019', '2.00', NULL, '2.00', '0.00', '4.00', '01', '', NULL, NULL),
('0110', '0087', '0027', '0027-0016', '00001111', '0027-0020', '100.00', NULL, '1.00', '99.00', '1.00', '01', '', NULL, NULL),
('0111', '0088', '0027', '0027-0017', '00666', '0027-0019', '250.00', NULL, '10.00', '20.00', '2000.00', '01', '', NULL, NULL),
('0112', '0089', '0027', '0027-0016', '00001111', '0027-0020', '150.00', NULL, '10.00', '20.00', '1200.00', '01', '', NULL, NULL),
('0113', '0090', '0027', '0027-0017', '00666', '0027-0019', '22.00', NULL, '2.00', '10.00', '39.60', '01', '', NULL, NULL),
('0114', '0090', '0027', '0027-0006', '00001', '0027-0021', '23.00', NULL, '2.00', '10.00', '41.40', '01', '', NULL, NULL),
('0115', '0090', '0027', '0027-0005', 'A0001', '0027-0021', '2.00', NULL, '2.00', '10.00', '3.60', '01', '', NULL, NULL),
('0116', '0091', '0027', '0027-0018', 'msi0001', '0027-0021', '440.00', NULL, '2.00', '0.00', '880.00', '01', 'They free ...', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_purchase_order`
--

CREATE TABLE `pos_tbl_purchase_order` (
  `pur_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `sup_id` varchar(45) DEFAULT NULL,
  `pur_invoice` varchar(45) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_purchase_order`
--

INSERT INTO `pos_tbl_purchase_order` (`pur_id`, `branchcode`, `sup_id`, `pur_invoice`, `remark`, `inputter`, `inputdate`, `sys_token`) VALUES
('0001', '0001', '0001-0001', 'NO00022', '', 'bongmap@gmail.com', '2021-03-28 10:19:43', '0001-605ff5cfc0d6d'),
('0001', '0004', '0004-0002', 'INC0002', 'Buy only 3', 'technodemo@gmail.com', '2021-03-29 15:03:30', '0004-6061ec421e722'),
('0001', '0167', '0167-0001', 'NA00001', 'top remark', 'demopos@gmail.com', '2021-03-24 20:54:15', '0167-605b448735e74'),
('0001', '0168', '0168-0002', 'H20-0521', 'buy mouse G102 =3', 'TECHNOZOON@gmail.com', '2021-04-05 09:28:22', '0168-606ad83617fbf'),
('0002', '0001', '0001-0001', 'NA00001', '', 'bongmap@gmail.com', '2021-03-28 10:30:35', '0001-605ff85b40e92'),
('0002', '0004', '0004-0002', 'INC0002', 'Buy only 3', 'technodemo@gmail.com', '2021-03-29 15:05:14', '0004-6061ecaa6bb8b'),
('0002', '0168', '0168-0003', 'N/A', 'Purchase 08/04/2020', 'bongratha@gmail.com', '2021-04-09 10:57:41', '0168-6070332564076'),
('0003', '0004', '0004-0003', 'INV0001', 'for connector', 'technodemo@gmail.com', '2021-03-30 09:19:24', '0004-6062ed1c45fb8'),
('0003', '0168', '0168-0003', 'n/a', '', 'bongratha@gmail.com', '2021-04-13 08:30:25', '0168-607556a199e18'),
('0004', '0004', '0004-0002', 'IN00002', 'for replace', 'technodemo@gmail.com', '2021-03-30 09:34:02', '0004-6062f08a433b1'),
('0004', '0168', '0168-0001', '81150063001021937', 'from alibaba ', 'TECHNOZOON@gmail.com', '2021-04-28 02:58:49', '0168-6088cf69b4c20'),
('0005', '0168', '0168-0003', '82142059001021937', '', 'TECHNOZOON@gmail.com', '2021-05-09 15:06:17', '0168-6097fa694cb74'),
('0006', '0168', '0168-0003', 'KK600000118369', '', 'TECHNOZOON@gmail.com', '2021-05-09 15:08:01', '0168-6097fad1adb88'),
('0007', '0168', '0168-0003', '518949773804', '', 'TECHNOZOON@gmail.com', '2021-05-13 05:49:50', '0168-609cbdfe9e2ba'),
('0008', '0168', '0168-0003', '73155597284116', '', 'TECHNOZOON@gmail.com', '2021-05-22 00:53:44', '0168-60a856181c015'),
('0009', '0168', '0168-0003', 'ZTO - 73161479173485', 'ZTO - 73161479173485', 'TECHNOZOON@gmail.com', '2021-07-20 06:21:07', '0168-60f66b5317937'),
('0010', '0168', '0168-0003', 'ZTO - 73161479173485', '', 'TECHNOZOON@gmail.com', '2021-07-20 06:23:34', '0168-60f66be6071ae'),
('0011', '0168', '0168-0003', '900851764728', '', 'TECHNOZOON@gmail.com', '2021-08-04 09:47:53', '0168-610a624995fc8'),
('0012', '0168', '0168-0003', '900855827649', '', 'technozoon@gmail.com', '2021-08-30 01:35:50', '0168-612c35f65561d'),
('0027-0043', '0027', '0027-0004', 'NA00001', 'top remark', 'bongmap@gmail.com', '2021-03-18 15:04:23', '0027-60530987d6a58'),
('0027-0055', '0027', '0027-0004', 'NO00022', 's', 'bongmap@gmail.com', '2021-03-19 11:12:04', '0027-6054249409c7f'),
('0027-0062', '0027', '0027-0015', 'NA00001', 'top remark', 'bongmap@gmail.com', '2021-03-19 13:19:16', '0027-60544264d7873'),
('0063', '0027', '0027-0004', 'wwww', 'Remark sale', 'bongmap@gmail.com', '2021-03-19 13:21:49', '0027-605442fd69068'),
('0064', '0027', '0027-0004', 'NO00022', 'sell home', 'bongmap@gmail.com', '2021-03-19 14:55:25', '0027-605458edc555c'),
('0065', '0027', '0027-0015', 'NO000123', 'top remark', 'bongmap@gmail.com', '2021-03-19 14:56:08', '0027-6054591850776'),
('0074', '0027', '0027-0015', 'In0001', 'Remark sale', 'bongmap@gmail.com', '2021-03-19 20:22:02', '0027-6054a57a551a1'),
('0075', '0027', '0027-0004', 'NO00022', 'top remark', 'bongmap@gmail.com', '2021-03-19 20:27:45', '0027-6054a6d1c8ea5'),
('0076', '0027', '0027-0004', 'NA00001', 'top remark', 'bongmap@gmail.com', '2021-03-20 10:11:00', '0027-605567c421240'),
('0077', '0027', '0027-0004', 'NO00022', 'top remark', 'bongmap@gmail.com', '2021-03-20 11:08:38', '0027-605575463b275'),
('0078', '0027', '0027-0004', 'NO00022', 'Remark sale', 'bongmap@gmail.com', '2021-03-20 11:19:57', '0027-605577eda5f34'),
('0079', '0027', '0027-0004', 'NO00022', 'for sale', 'bongmap@gmail.com', '2021-03-20 11:21:46', '0027-6055785a6e106'),
('0080', '0027', '0027-0004', 'In0001', 'Remark sale', 'bongmap@gmail.com', '2021-03-20 11:42:22', '0027-60557d2ee170f'),
('0081', '0027', '0027-0015', 'NA000010', '', 'bongmap@gmail.com', '2021-03-20 11:49:34', '0027-60557ede03054'),
('0082', '0027', '0027-0004', 'In0001', '', 'bongmap@gmail.com', '2021-03-20 11:50:06', '0027-60557efe05a82'),
('0083', '0027', '0027-0004', 'NO00022', 'top remark', 'bongmap@gmail.com', '2021-03-20 11:51:34', '0027-60557f56543df'),
('0084', '0027', '0027-0004', 'NO00022', '', 'bongmap@gmail.com', '2021-03-20 11:52:46', '0027-60557f9e28fd0'),
('0085', '0027', '0027-0004', 'NO00022', 'remark', 'bongmap@gmail.com', '2021-03-20 11:53:28', '0027-60557fc8acdfc'),
('0086', '0027', '0027-0004', 'NO00022', 'Remark sale', 'bongmap@gmail.com', '2021-03-20 15:55:01', '0027-6055b865c4769'),
('0087', '0027', '0027-0015', 'NA000010', 'Remark sale', 'bongmap@gmail.com', '2021-03-21 14:27:43', '0027-6056f56f4a64c'),
('0088', '0027', '0027-0015', 'NA000010', 'top remark', 'bongmap@gmail.com', '2021-03-23 13:41:30', '0027-60598d9ade45c'),
('0089', '0027', '0027-0015', 'NO00022', '', 'bongmap@gmail.com', '2021-03-23 14:42:03', '0027-60599bcb034b2'),
('0090', '0027', '0027-0015', 'NA000010', 'Remark sale', 'bongmap@gmail.com', '2021-03-23 21:13:10', '0027-6059f77633ff3'),
('0091', '0027', '0027-0016', 'NO00022', '', 'bongmap@gmail.com', '2021-03-25 13:49:26', '0027-605c3276dbd6e');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_stockouts`
--

CREATE TABLE `pos_tbl_stockouts` (
  `sto_num` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `inv_num` varchar(50) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `pro_barcode` varchar(10) DEFAULT NULL,
  `stock_code` varchar(10) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_qty` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pro_amount` decimal(13,2) DEFAULT NULL,
  `pro_qty_amount` decimal(13,2) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_stockout_return`
--

CREATE TABLE `pos_tbl_stockout_return` (
  `sto_num` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `inv_num` varchar(50) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `pro_barcode` varchar(10) DEFAULT NULL,
  `stock_code` varchar(10) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_qty` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pro_amount` decimal(13,2) DEFAULT NULL,
  `pro_qty_amount` decimal(13,2) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_stockout_return`
--

INSERT INTO `pos_tbl_stockout_return` (`sto_num`, `branchcode`, `inv_num`, `pro_code`, `pro_barcode`, `stock_code`, `pro_cost`, `pro_qty`, `pro_up`, `pro_discount`, `pro_amount`, `pro_qty_amount`, `trandate`) VALUES
('0003', '0004', '0007', '0004-0002', 'A0002', '0004-0005', '155.00', '1.00', '165.00', '0.00', '165.00', NULL, NULL),
('0013', '0004', '0013', '0004-0001', 'A0001', '0004-0005', '15.00', '2.00', '21.50', '0.00', '43.00', NULL, NULL),
('0016', '0001', '0020', '0001-0001', 'T0001', '0001-0001', '16.00', '2.00', '20.00', '0.00', '40.00', NULL, NULL),
('0017', '0001', '0021', '0001-0001', 'T0001', '0001-0001', '16.00', '2.00', '20.00', '0.00', '40.00', NULL, NULL),
('0018', '0001', '0021', '0001-0002', 'T0002', '0001-0001', '150.00', '3.00', '170.00', '0.00', '510.00', NULL, NULL),
('0019', '0001', '0022', '0001-0001', 'T0001', '0001-0002', '16.00', '50.00', '20.00', '0.00', '1000.00', NULL, NULL),
('0020', '0001', '0023', '0001-0001', 'T0001', '0001-0001', '16.00', '1.00', '20.00', '0.00', '20.00', NULL, NULL),
('0021', '0001', '0023', '0001-0002', 'T0002', '0001-0002', '150.00', '1.00', '170.00', '0.00', '170.00', NULL, NULL),
('0022', '0001', '0024', '0001-0001', 'T0001', '0001-0001', '16.00', '8.00', '20.00', '0.00', '160.00', NULL, NULL),
('0042', '0168', '0041', '0168-0028', 'B0020', '0168-0004', '31.00', '1.00', '45.00', '0.00', '45.00', NULL, NULL),
('0043', '0168', '0041', '0168-0037', '0040', '0168-0004', '50.00', '1.00', '85.00', '0.00', '85.00', NULL, NULL),
('0054', '0168', '0052', '0168-0042', 'B0045', '0168-0004', '27.00', '1.00', '65.00', '0.00', '65.00', NULL, NULL),
('0057', '0168', '0055', '0168-0042', 'B0045', '0168-0004', '27.00', '1.00', '65.00', '0.00', '65.00', NULL, NULL),
('0058', '0168', '0056', '0168-0028', 'B0020', '0168-0004', '31.00', '1.00', '45.00', '0.00', '45.00', NULL, NULL),
('0059', '0168', '0056', '0168-0037', '0040', '0168-0004', '50.00', '1.00', '85.00', '0.00', '85.00', NULL, NULL),
('0060', '0168', '0057', '0168-0029', '0033', '0168-0004', '27.00', '1.00', '49.00', '0.00', '49.00', NULL, NULL),
('0070', '0168', '0067', '0168-0042', 'B0045', '0168-0004', '27.00', '1.00', '65.00', '0.00', '65.00', NULL, NULL),
('0071', '0168', '0068', '0168-0024', 'B0016', '0168-0004', '9.00', '1.00', '20.00', '0.00', '20.00', NULL, NULL),
('0072', '0168', '0069', '0168-0022', 'B0014', '0168-0004', '21.00', '1.00', '47.00', '0.00', '47.00', NULL, NULL),
('0073', '0168', '0070', '0168-0022', 'B0014', '0168-0004', '21.00', '1.00', '47.00', '0.00', '47.00', NULL, NULL),
('0074', '0168', '0071', '0168-0029', '0033', '0168-0004', '27.00', '1.00', '44.00', '0.00', '44.00', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_stocks`
--

CREATE TABLE `pos_tbl_stocks` (
  `stk_code` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `stk_name` varchar(150) DEFAULT NULL,
  `stk_inactive` int(11) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_stocktransfer`
--

CREATE TABLE `pos_tbl_stocktransfer` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `f_stock` varchar(20) DEFAULT NULL,
  `t_stock` varchar(20) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_stocktransfer`
--

INSERT INTO `pos_tbl_stocktransfer` (`tran_code`, `branchcode`, `f_stock`, `t_stock`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `sys_token`) VALUES
('0001', '0004', '0004-0003', '0004-0004', 'for sale', 'technodemo@gmail.com', '2021-03-29 15:07:25', 'technodemo@gmail.com', '2021-03-29 15:07:51', '0004-6061ed2cec3cd'),
('0001', '0168', '0168-0004', '0168-0003', 'Mr.Map get for testing at home', 'TECHNOZOON@gmail.com', '2021-08-12 11:05:22', 'TECHNOZOON@gmail.com', '2021-08-12 11:05:27', '0168-611500723551e'),
('0003', '0001', '0001-0001', '0001-0002', NULL, 'bongmap@gmail.com', '2021-03-28 10:28:54', 'bongmap@gmail.com', '2021-03-28 10:28:59', '0001-605ff7f650bb2'),
('0004', '0004', '0004-0004', '0004-0003', NULL, 'technodemo@gmail.com', '2021-03-30 09:36:22', 'technodemo@gmail.com', '2021-03-30 09:36:39', '0004-6062f1167f90f'),
('0008', '0168', '0168-0004', '0168-0003', 'Mr.Makara take to use', 'TECHNOZOON@gmail.com', '2021-08-16 10:54:25', 'TECHNOZOON@gmail.com', '2021-08-16 10:54:31', '0168-611a43e1b7ab3'),
('0031', '0027', '0027-0019', '0027-0020', NULL, 'bongmap@gmail.com', '2021-03-26 12:43:10', 'bongmap@gmail.com', '2021-03-26 12:44:08', '0027-605d746e7c7c7'),
('0033', '0027', '0027-0019', '0027-0020', NULL, 'bongmap@gmail.com', '2021-03-26 12:46:05', 'bongmap@gmail.com', '2021-03-26 12:46:13', '0027-605d751d1822d'),
('0036', '0027', '0027-0019', '0027-0020', 'top remark', 'bongmap@gmail.com', '2021-03-26 12:53:32', 'bongmap@gmail.com', '2021-03-26 12:53:42', '0027-605d76dc1f228'),
('0038', '0027', '0027-0020', '0027-0021', 'top remark', 'bongmap@gmail.com', '2021-03-26 13:01:51', 'bongmap@gmail.com', '2021-03-26 13:01:56', '0027-605d78cef306f'),
('0040', '0027', '0027-0019', '0027-0021', 'Remark sale', 'bongmap@gmail.com', '2021-03-26 13:04:51', 'bongmap@gmail.com', '2021-03-26 13:05:05', '0027-605d79832b7af'),
('0042', '0027', '0027-0019', '0027-0020', NULL, 'bongmap@gmail.com', '2021-03-26 13:06:21', 'bongmap@gmail.com', '2021-03-26 13:06:27', '0027-605d79ddc6ba5'),
('0044', '0027', '0027-0019', '0027-0020', 'top remark', 'bongmap@gmail.com', '2021-03-26 13:07:06', 'bongmap@gmail.com', '2021-03-26 13:07:13', '0027-605d7a0a829bc'),
('0046', '0027', '0027-0019', '0027-0020', 'top remark', 'bongmap@gmail.com', '2021-03-26 13:19:49', 'bongmap@gmail.com', '2021-03-26 13:19:53', '0027-605d7d0517a7d'),
('0048', '0027', '0027-0019', '0027-0020', NULL, 'bongmap@gmail.com', '2021-03-26 13:20:39', 'bongmap@gmail.com', '2021-03-26 13:20:45', '0027-605d7d37b07a6'),
('0051', '0027', '0027-0020', '0027-0019', 'Remark sale', 'bongmap@gmail.com', '2021-03-26 13:24:28', 'bongmap@gmail.com', '2021-03-26 13:24:34', '0027-605d7e1c8881d');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_stocktransfer_detail`
--

CREATE TABLE `pos_tbl_stocktransfer_detail` (
  `sysdocnum` varchar(20) NOT NULL,
  `branchcode` varchar(20) DEFAULT NULL,
  `tran_code` varchar(20) DEFAULT NULL,
  `pro_code` varchar(20) DEFAULT NULL,
  `barcode` varchar(20) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_stocktransfer_detail`
--

INSERT INTO `pos_tbl_stocktransfer_detail` (`sysdocnum`, `branchcode`, `tran_code`, `pro_code`, `barcode`, `qty`) VALUES
('0002', '0004', '0001', '0004-0001', 'A0001', '2.00'),
('0003', '0004', '0001', '0004-0002', 'A0002', '1.00'),
('0004', '0001', '0003', '0001-0001', 'T0001', '3.00'),
('0005', '0004', '0004', '0004-0001', 'A0001', '80.00'),
('0009', '0168', '0008', '0168-0011', 'B0004', '1.00'),
('0032', NULL, '0031', '0027-0018', 'msi0001', '2.00'),
('0034', NULL, '0033', '0027-0018', 'msi0001', '2.00'),
('0035', NULL, '0033', '0027-0016', '00001111', '2.00'),
('0037', '0027', '0036', '0027-0018', 'msi0001', '2.00'),
('0039', '0027', '0038', '0027-0017', '00666', '3.00'),
('0041', '0027', '0040', '0027-0005', 'A0001', '100.00'),
('0043', '0027', '0042', '0027-0019', 'msi0002', '250.00'),
('0045', '0027', '0044', '0027-0019', 'msi0002', '250.00'),
('0047', '0027', '0046', '0027-0005', 'A0001', '10.00'),
('0049', '0027', '0048', '0027-0005', 'A0001', '290.00'),
('0050', '0027', '0048', '0027-0018', 'msi0001', '2.00'),
('0052', '0027', '0051', '0027-0005', 'A0001', '500.00');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_supplier`
--

CREATE TABLE `pos_tbl_supplier` (
  `sup_id` varchar(10) NOT NULL,
  `branchcode` varchar(45) NOT NULL,
  `sup_name` varchar(45) DEFAULT NULL,
  `sup_type` varchar(20) DEFAULT NULL,
  `sup_phone` varchar(45) DEFAULT NULL,
  `sup_email` varchar(45) DEFAULT NULL,
  `sup_address` varchar(45) DEFAULT NULL,
  `sup_website` varchar(45) DEFAULT NULL,
  `inactive` varchar(10) DEFAULT NULL,
  `sub_fax` varchar(45) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_supplier`
--

INSERT INTO `pos_tbl_supplier` (`sup_id`, `branchcode`, `sup_name`, `sup_type`, `sup_phone`, `sup_email`, `sup_address`, `sup_website`, `inactive`, `sub_fax`, `inputter`, `inputdate`) VALUES
('0001-0001', '0001', 'General', '0001-0010', '078500333', 'abc@gmail.com', 'phnom penh thmey', 'www.toanchet.com', '0', NULL, 'bongmap@gmail.com', '2021-03-28 10:19:21'),
('0004-0001', '0004', 'General', '0004-0011', '070500987', 'technozooncambodia@gmail.com', 'Phnom penh', 'www.technozoon.com', '0', NULL, 'technodemo@gmail.com', '2021-03-29 15:00:01'),
('0004-0002', '0004', 'Chantra Computer', '0004-0012', '010500666', 'Chantra @gmail.com', 'Phnom penh', 'www.Chantrapc.com', '0', NULL, 'technodemo@gmail.com', '2021-03-29 15:00:50'),
('0004-0003', '0004', 'S&H store', '0004-0012', '099998877', 'yemmai313K@gmail.com', 'phnom penh , prek tamak', 'N/A', '0', NULL, 'technodemo@gmail.com', '2021-03-30 09:16:02'),
('0004-0004', '0004', 'Technozoon', '0004-0011', '078500333', 'puit.official@gmail.com', 'phnom penh thmey', 'www.toanchet.com', '0', NULL, 'technodemo@gmail.com', '2021-04-09 06:08:58'),
('0027-0004', '0027', 'VSP', '0027-0016', '078500313', 'home@gmail.com', 'Kompot', 'www.toanchet.com', '0', NULL, 'bongmap@gmail.com', '2021-02-28 14:04:35'),
('0027-0015', '0027', 'Bong Map', '0027-0016', '010500666', 'progamil.com', 'ddd', 'www.icream.com', '0', NULL, 'bongmap@gmail.com', '2021-03-15 09:16:10'),
('0027-0016', '0027', 'CHANTRA computer shop', '0027-0016', '099998877,010500313', NULL, 'Phnom penh', 'www.chantracomputer', '0', NULL, 'bongmap@gmail.com', '2021-03-25 13:39:03'),
('0167-0001', '0167', 'General', '0167-0010', '010500313', NULL, 'phnom penh', 'www.technozoon.com', '0', NULL, 'demopos@gmail.com', '2021-03-24 19:05:40'),
('0168-0001', '0168', 'General', '0168-0021', '070500987', 'Technozoon@gmail.com', 'phnom penh', 'www.technozoon.com', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 09:25:54'),
('0168-0002', '0168', 'Home gear', '0168-0021', '087-089-356256', 'N/A', 'phnom penh', 'N/A', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-05 09:27:04'),
('0168-0003', '0168', 'Alibaba', '0168-0021', '010500313', 'alibaba@gmail.com', 'alibaba.com', 'www.alibaba.com', '0', NULL, 'TECHNOZOON@gmail.com', '2021-04-07 13:32:21');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_transactions`
--

CREATE TABLE `pos_tbl_transactions` (
  `sysdocnum` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `pro_barcode` varchar(10) DEFAULT NULL,
  `trancode` varchar(20) DEFAULT NULL,
  `stockcode` varchar(20) DEFAULT NULL,
  `trn_status` varchar(45) DEFAULT NULL,
  `trn_ref` varchar(10) DEFAULT NULL,
  `trn_qty` decimal(13,4) DEFAULT NULL,
  `trn_qty_tt` decimal(13,4) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_transactions`
--

INSERT INTO `pos_tbl_transactions` (`sysdocnum`, `branchcode`, `pro_code`, `pro_barcode`, `trancode`, `stockcode`, `trn_status`, `trn_ref`, `trn_qty`, `trn_qty_tt`, `inputter`, `inputdate`) VALUES
('0001', '0168', '0168-0001', 'A0001', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0002', '0168', '0168-0001', 'A0001', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0003', '0168', '0168-0002', 'A0002', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0004', '0168', '0168-0002', 'A0002', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0005', '0168', '0168-0013', 'B0006', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0006', '0168', '0168-0013', 'B0006', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0007', '0168', '0168-0014', 'B0007', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0008', '0168', '0168-0014', 'B0007', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0009', '0168', '0168-0008', 'B0001', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0010', '0168', '0168-0008', 'B0001', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0011', '0168', '0168-0009', 'B0002', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0012', '0004', '0004-0001', 'A0001', '06', '0004-0004', 'cut_count_stock', '0010', '0.0000', '0.0000', 'technodemo@gmail.com', '2021-03-30 02:29:38'),
('0012', '0168', '0168-0009', 'B0002', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0013', '0004', '0004-0001', 'A0001', '07', '0004-0004', 'count_stock', '0010', '10.0000', '10.0000', 'technodemo@gmail.com', '2021-03-30 02:29:38'),
('0013', '0168', '0168-0010', 'B0003', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0014', '0004', '0004-0001', 'A0001', '06', '0004-0004', 'cut_count_stock', '0013', '-10.0000', '0.0000', 'technodemo@gmail.com', '2021-03-30 02:30:46'),
('0014', '0168', '0168-0010', 'B0003', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0015', '0004', '0004-0001', 'A0001', '07', '0004-0004', 'count_stock', '0013', '10.0000', '10.0000', 'technodemo@gmail.com', '2021-03-30 02:30:46'),
('0015', '0168', '0168-0011', 'B0004', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0016', '0004', '0004-0001', 'A0001', '06', '0004-0004', 'cut_count_stock', '0019', '-10.0000', '0.0000', 'technodemo@gmail.com', '2021-03-30 02:40:00'),
('0016', '0168', '0168-0011', 'B0004', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0017', '0004', '0004-0001', 'A0001', '07', '0004-0004', 'count_stock', '0019', '110.0000', '110.0000', 'technodemo@gmail.com', '2021-03-30 02:40:00'),
('0017', '0168', '0168-0012', 'B0005', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0018', '0004', '0004-0001', 'A0001', '06', '0004-0004', 'cut_count_stock', '0022', '-110.0000', '0.0000', 'technodemo@gmail.com', '2021-03-30 02:42:47'),
('0018', '0168', '0168-0012', 'B0005', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0019', '0004', '0004-0001', 'A0001', '07', '0004-0004', 'count_stock', '0022', '100.0000', '100.0000', 'technodemo@gmail.com', '2021-03-30 02:42:47'),
('0019', '0168', '0168-0016', 'B0009', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0020', '0004', '0004-0002', 'A0002', '06', '0004-0004', 'cut_count_stock', '0022', '0.0000', '0.0000', 'technodemo@gmail.com', '2021-03-30 02:42:47'),
('0020', '0168', '0168-0016', 'B0009', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0021', '0004', '0004-0002', 'A0002', '07', '0004-0004', 'count_stock', '0022', '220.0000', '220.0000', 'technodemo@gmail.com', '2021-03-30 02:42:47'),
('0021', '0168', '0168-0015', 'B0008', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0022', '0004', '0004-0001', 'A0001', '02', '0004-0004', 'auth_pos_invoice', '0010', '-9.0000', '91.0000', 'technodemo@gmail.com', '2021-03-30 02:56:49'),
('0022', '0168', '0168-0015', 'B0008', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0023', '0004', '0004-0002', 'A0002', '02', '0004-0004', 'auth_pos_invoice', '0010', '-9.0000', '211.0000', 'technodemo@gmail.com', '2021-03-30 02:56:49'),
('0023', '0168', '0168-0003', 'A0003', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0024', '0004', '0004-0004', 'A0010', '01', '0004-0003', 'purchaseorder', '0003', '10.0000', '10.0000', 'technodemo@gmail.com', '2021-03-30 09:20:47'),
('0024', '0168', '0168-0003', 'A0003', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0025', '0004', '0004-0001', 'A0001', '01', '0004-0003', 'purchaseorder', '0003', '5.0000', '5.0000', 'technodemo@gmail.com', '2021-03-30 09:20:47'),
('0025', '0168', '0168-0004', 'A0004', '06', '0168-0004', 'cut_count_stock', '0001', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0026', '0004', '0004-0001', 'A0001', '02', '0004-0004', 'auth_pos_invoice', '0011', '-1.0000', '90.0000', 'technodemo@gmail.com', '2021-03-30 09:29:58'),
('0026', '0168', '0168-0004', 'A0004', '07', '0168-0004', 'count_stock', '0001', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-03-31 09:29:37'),
('0027', '0004', '0004-0004', 'A0010', '02', '0004-0003', 'auth_pos_invoice', '0011', '-5.0000', '5.0000', 'technodemo@gmail.com', '2021-03-30 09:29:58'),
('0027', '0168', '0168-0010', 'B0003', '02', '0168-0004', 'auth_pos_invoice', '0003', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-04-05 09:22:49'),
('0028', '0004', '0004-0001', 'A0001', '02', '0004-0003', 'auth_pos_invoice', '0012', '-10.0000', '-5.0000', 'technodemo@gmail.com', '2021-03-30 09:32:19'),
('0028', '0168', '0168-0001', 'A0001', '01', '0168-0004', 'purchaseorder', '0001', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-04-05 09:28:30'),
('0029', '0004', '0004-0004', 'A0010', '02', '0004-0003', 'auth_pos_invoice', '0012', '-10.0000', '-5.0000', 'technodemo@gmail.com', '2021-03-30 09:32:19'),
('0029', '0168', '0168-0001', 'A0001', '02', '0168-0004', 'auth_pos_invoice', '0004', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-05 09:30:21'),
('0030', '0004', '0004-0001', 'A0001', '01', '0004-0003', 'purchaseorder', '0004', '15.0000', '10.0000', 'technodemo@gmail.com', '2021-03-30 09:34:21'),
('0030', '0168', '0168-0001', 'A0001', '02', '0168-0004', 'auth_pos_invoice', '0005', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-04-05 09:32:06'),
('0031', '0004', '0004-0004', 'A0010', '01', '0004-0003', 'purchaseorder', '0004', '6.0000', '1.0000', 'technodemo@gmail.com', '2021-03-30 09:34:21'),
('0031', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0015', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31'),
('0032', '0004', '0004-0001', 'A0001', '04', '0004-0004', 'f_stocktransfer', '0004', '-80.0000', '10.0000', 'technodemo@gmail.com', '2021-03-30 09:36:39'),
('0032', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0015', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31'),
('0033', '0004', '0004-0001', 'A0001', '03', '0004-0003', 't_stocktransfer', '0004', '80.0000', '90.0000', 'technodemo@gmail.com', '2021-03-30 09:36:39'),
('0033', '0168', '0168-0007', 'A0007', '06', '0168-0004', 'cut_count_stock', '0015', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31'),
('0034', '0004', '0004-0001', 'A0001', '09', '0004-0005', 'return_invoice', '0013', '2.0000', '2.0000', 'technodemo@gmail.com', '2021-03-30 09:39:59'),
('0034', '0168', '0168-0007', 'A0007', '07', '0168-0004', 'count_stock', '0015', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31'),
('0035', '0004', '0004-0001', 'A0001', '06', '0004-0005', 'cut_count_stock', '0025', '-2.0000', '0.0000', 'technodemo@gmail.com', '2021-04-09 06:09:45'),
('0035', '0168', '0168-0017', 'B0010', '06', '0168-0004', 'cut_count_stock', '0015', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31'),
('0036', '0004', '0004-0001', 'A0001', '07', '0004-0005', 'count_stock', '0025', '150.0000', '150.0000', 'technodemo@gmail.com', '2021-04-09 06:09:45'),
('0036', '0168', '0168-0017', 'B0010', '07', '0168-0004', 'count_stock', '0015', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:41:31'),
('0037', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0019', '-2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39'),
('0038', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0019', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39'),
('0039', '0168', '0168-0007', 'A0007', '06', '0168-0004', 'cut_count_stock', '0019', '-2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39'),
('0040', '0168', '0168-0007', 'A0007', '07', '0168-0004', 'count_stock', '0019', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39'),
('0041', '0168', '0168-0017', 'B0010', '06', '0168-0004', 'cut_count_stock', '0019', '-2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39'),
('0042', '0168', '0168-0017', 'B0010', '07', '0168-0004', 'count_stock', '0019', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:42:39'),
('0043', '0168', '0168-0018', 'B00011', '06', '0168-0004', 'cut_count_stock', '0023', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:58:54'),
('0044', '0168', '0168-0018', 'B00011', '07', '0168-0004', 'count_stock', '0023', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-04-07 13:58:54'),
('0045', '0168', '0168-0015', 'B0008', '02', '0168-0004', 'auth_pos_invoice', '0006', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-04-08 07:22:59'),
('0046', '0168', '0168-0009', 'B0002', '06', '0168-0004', 'cut_count_stock', '0027', '-1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-09 10:50:36'),
('0047', '0168', '0168-0009', 'B0002', '07', '0168-0004', 'count_stock', '0027', '1.0000', '0.0000', 'bongratha@gmail.com', '2021-04-09 10:50:36'),
('0048', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0027', '-2.0000', '-2.0000', 'bongratha@gmail.com', '2021-04-09 10:50:36'),
('0049', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0027', '2.0000', '0.0000', 'bongratha@gmail.com', '2021-04-09 10:50:36'),
('0050', '0168', '0168-0019', 'B0012', '01', '0168-0004', 'purchaseorder', '0002', '5.0000', '5.0000', 'bongratha@gmail.com', '2021-04-09 10:57:49'),
('0051', '0168', '0168-0010', 'B0003', '01', '0168-0004', 'purchaseorder', '0002', '5.0000', '4.0000', 'bongratha@gmail.com', '2021-04-09 10:57:49'),
('0052', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0030', '-2.0000', '-2.0000', 'bongratha@gmail.com', '2021-04-09 11:02:25'),
('0053', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0030', '1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-09 11:02:25'),
('0054', '0168', '0168-0013', 'B0006', '06', '0168-0004', 'cut_count_stock', '0032', '-1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-09 11:06:13'),
('0055', '0168', '0168-0013', 'B0006', '07', '0168-0004', 'count_stock', '0032', '6.0000', '5.0000', 'bongratha@gmail.com', '2021-04-09 11:06:13'),
('0056', '0168', '0168-0001', 'A0001', '02', '0168-0004', 'auth_pos_invoice', '0007', '-1.0000', '0.0000', 'bongratha@gmail.com', '2021-04-10 09:10:13'),
('0057', '0168', '0168-0001', 'A0001', '02', '0168-0004', 'auth_pos_invoice', '0008', '-1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-10 09:10:20'),
('0058', '0001', '0001-0001', 'T0001', '01', '0001-0001', 'purchaseorder', '0001', '10.0000', '10.0000', 'bongmap@gmail.com', '2021-03-28 10:19:48'),
('0058', '0168', '0168-0019', 'B0012', '02', '0168-0004', 'auth_pos_invoice', '0010', '-1.0000', '4.0000', 'bongratha@gmail.com', '2021-04-13 06:40:36'),
('0059', '0001', '0001-0001', 'T0001', '02', '0001-0001', 'auth_pos_invoice', '0008', '-2.0000', '8.0000', 'bongmap@gmail.com', '2021-03-28 10:20:24'),
('0059', '0168', '0168-0020', 'b00012', '02', '0168-0004', 'auth_pos_invoice', '0011', '-1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-13 06:40:48'),
('0060', '0001', '0001-0001', 'T0001', '04', '0001-0001', 'f_stocktransfer', '0003', '-3.0000', '5.0000', 'bongmap@gmail.com', '2021-03-28 10:28:59'),
('0060', '0168', '0168-0021', 'B0013', '02', '0168-0004', 'auth_pos_invoice', '0012', '-1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-13 06:42:57'),
('0061', '0001', '0001-0001', 'T0001', '03', '0001-0002', 't_stocktransfer', '0003', '5.0000', '5.0000', 'bongmap@gmail.com', '2021-03-28 10:28:59'),
('0061', '0168', '0168-0021', 'B0013', '01', '0168-0004', 'purchaseorder', '0003', '9.0000', '8.0000', 'bongratha@gmail.com', '2021-04-13 08:30:41'),
('0062', '0001', '0001-0002', 'T0002', '01', '0001-0001', 'purchaseorder', '0002', '100.0000', '100.0000', 'bongmap@gmail.com', '2021-03-28 10:30:39'),
('0062', '0168', '0168-0020', 'b00012', '01', '0168-0004', 'purchaseorder', '0003', '1.0000', '0.0000', 'bongratha@gmail.com', '2021-04-13 08:30:41'),
('0063', '0001', '0001-0001', 'T0001', '01', '0001-0001', 'purchaseorder', '0002', '15.0000', '20.0000', 'bongmap@gmail.com', '2021-03-28 10:30:39'),
('0063', '0168', '0168-0021', 'B0013', '06', '0168-0004', 'cut_count_stock', '0034', '-8.0000', '0.0000', 'bongratha@gmail.com', '2021-04-13 08:32:02'),
('0064', '0001', '0001-0001', 'T0001', '02', '0001-0002', 'auth_pos_invoice', '0009', '-3.0000', '2.0000', 'bongmap@gmail.com', '2021-03-28 10:31:50'),
('0064', '0168', '0168-0021', 'B0013', '07', '0168-0004', 'count_stock', '0034', '9.0000', '9.0000', 'bongratha@gmail.com', '2021-04-13 08:32:02'),
('0065', '0001', '0001-0001', 'T0001', '02', '0001-0001', 'auth_pos_invoice', '0009', '-5.0000', '15.0000', 'bongmap@gmail.com', '2021-03-28 10:31:50'),
('0065', '0168', '0168-0020', 'b00012', '06', '0168-0004', 'cut_count_stock', '0036', '0.0000', '0.0000', 'bongratha@gmail.com', '2021-04-13 08:32:07'),
('0066', '0001', '0001-0002', 'T0002', '02', '0001-0001', 'auth_pos_invoice', '0010', '-9.0000', '91.0000', 'bongmap@gmail.com', '2021-03-28 10:42:43'),
('0066', '0168', '0168-0020', 'b00012', '07', '0168-0004', 'count_stock', '0036', '1.0000', '1.0000', 'bongratha@gmail.com', '2021-04-13 08:32:07'),
('0067', '0001', '0001-0001', 'T0001', '06', '0001-0001', 'cut_count_stock', '0022', '-15.0000', '0.0000', 'bongmap@gmail.com', '2021-03-28 12:26:09'),
('0067', '0168', '0168-0017', 'B0010', '06', '0168-0004', 'cut_count_stock', '0038', '-2.0000', '-2.0000', 'bongratha@gmail.com', '2021-04-13 08:59:38'),
('0068', '0001', '0001-0001', 'T0001', '07', '0001-0001', 'count_stock', '0022', '120.0000', '120.0000', 'bongmap@gmail.com', '2021-03-28 12:26:09'),
('0068', '0168', '0168-0017', 'B0010', '07', '0168-0004', 'count_stock', '0038', '1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-13 08:59:38'),
('0069', '0001', '0001-0001', 'T0001', '06', '0001-0001', 'cut_count_stock', '0026', '-120.0000', '0.0000', 'bongmap@gmail.com', '2021-03-28 22:30:30'),
('0069', '0168', '0168-0021', 'B0013', '06', '0168-0004', 'cut_count_stock', '0040', '-9.0000', '0.0000', 'bongratha@gmail.com', '2021-04-13 09:04:54'),
('0070', '0001', '0001-0001', 'T0001', '07', '0001-0001', 'count_stock', '0026', '2.0000', '2.0000', 'bongmap@gmail.com', '2021-03-28 22:30:30'),
('0070', '0168', '0168-0021', 'B0013', '07', '0168-0004', 'count_stock', '0040', '8.0000', '8.0000', 'bongratha@gmail.com', '2021-04-13 09:04:54'),
('0071', '0001', '0001-0001', 'T0001', '09', '0001-0001', 'return_invoice', '0020', '2.0000', '2.0000', 'bongmap@gmail.com', '2021-03-29 10:39:50'),
('0071', '0168', '0168-0017', 'B0010', '06', '0168-0004', 'cut_count_stock', '0042', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-04-13 09:30:34'),
('0072', '0001', '0001-0001', 'T0001', '09', '0001-0001', 'return_invoice', '0021', '2.0000', '4.0000', 'bongmap@gmail.com', '2021-03-29 10:43:41'),
('0072', '0168', '0168-0017', 'B0010', '07', '0168-0004', 'count_stock', '0042', '0.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-04-13 09:30:34'),
('0073', '0001', '0001-0002', 'T0002', '09', '0001-0001', 'return_invoice', '0021', '3.0000', '94.0000', 'bongmap@gmail.com', '2021-03-29 10:43:41'),
('0073', '0168', '0168-0020', 'b00012', '06', '0168-0004', 'cut_count_stock', '0042', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-13 09:30:34'),
('0074', '0001', '0001-0001', 'T0001', '09', '0001-0002', 'return_invoice', '0022', '12.0000', '12.0000', 'bongmap@gmail.com', '2021-03-29 10:47:35'),
('0074', '0168', '0168-0020', 'b00012', '07', '0168-0004', 'count_stock', '0042', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-13 09:30:34'),
('0075', '0001', '0001-0001', 'T0001', '09', '0001-0001', 'return_invoice', '0023', '1.0000', '5.0000', 'bongmap@gmail.com', '2021-03-29 11:18:22'),
('0075', '0168', '0168-0018', 'B00011', '02', '0168-0004', 'auth_pos_invoice', '0014', '-1.0000', '-1.0000', 'bongratha@gmail.com', '2021-04-15 04:38:02'),
('0076', '0001', '0001-0002', 'T0002', '09', '0001-0002', 'return_invoice', '0023', '1.0000', '92.0000', 'bongmap@gmail.com', '2021-03-29 11:18:22'),
('0076', '0168', '0168-0018', 'B00011', '02', '0168-0004', 'auth_pos_invoice', '0016', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-04-27 14:14:33'),
('0077', '0001', '0001-0001', 'T0001', '09', '0001-0001', 'return_invoice', '0024', '8.0000', '13.0000', 'bongmap@gmail.com', '2021-03-29 11:22:46'),
('0077', '0168', '0168-0022', 'B0014', '01', '0168-0004', 'purchaseorder', '0004', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-04-28 02:59:04'),
('0078', '0001', '0001-0001', 'T0001', '02', '0001-0002', 'auth_pos_invoice', '0025', '-10.0000', '2.0000', 'bongmap@gmail.com', '2021-03-29 12:32:08'),
('0078', '0168', '0168-0023', 'B0015', '01', '0168-0004', 'purchaseorder', '0004', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-28 02:59:04'),
('0079', '0168', '0168-0010', 'B0003', '02', '0168-0004', 'auth_pos_invoice', '0017', '-1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-04-28 03:19:56'),
('0080', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0045', '-1.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-04-30 06:24:59'),
('0081', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0045', '2.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-04-30 06:24:59'),
('0082', '0168', '0168-0005', 'A0005', '06', '0168-0004', 'cut_count_stock', '0047', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-04-30 14:04:41'),
('0083', '0168', '0168-0005', 'A0005', '07', '0168-0004', 'count_stock', '0047', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-04-30 14:04:41'),
('0084', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0019', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-03 05:59:40'),
('0085', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0020', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-03 06:03:23'),
('0086', '0168', '0168-0012', 'B0005', '02', '0168-0004', 'auth_pos_invoice', '0023', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-05 09:45:21'),
('0087', '0168', '0168-0018', 'B00011', '02', '0168-0004', 'auth_pos_invoice', '0025', '-1.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-05-05 09:45:26'),
('0088', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0026', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-08 04:32:47'),
('0089', '0168', '0168-0023', 'B0015', '02', '0168-0004', 'auth_pos_invoice', '0028', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-08 04:36:51'),
('0090', '0168', '0168-0024', 'B0016', '01', '0168-0004', 'purchaseorder', '0005', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-05-09 15:06:21'),
('0091', '0168', '0168-0025', 'B0017', '01', '0168-0004', 'purchaseorder', '0005', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-05-09 15:06:21'),
('0092', '0168', '0168-0026', 'B0018', '01', '0168-0004', 'purchaseorder', '0005', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-05-09 15:06:21'),
('0093', '0168', '0168-0027', 'B0019', '01', '0168-0004', 'purchaseorder', '0006', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-09 15:08:06'),
('0094', '0168', '0168-0028', 'B0020', '01', '0168-0004', 'purchaseorder', '0006', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-09 15:08:06'),
('0095', '0168', '0168-0006', 'A0006', '02', '0168-0004', 'auth_pos_invoice', '0030', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-10 05:54:05'),
('0096', '0168', '0168-0023', 'B0015', '02', '0168-0004', 'auth_pos_invoice', '0031', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-10 06:03:47'),
('0097', '0168', '0168-0019', 'B0012', '02', '0168-0004', 'auth_pos_invoice', '0032', '-1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-11 09:40:11'),
('0098', '0168', '0168-0002', 'A0002', '02', '0168-0004', 'auth_pos_invoice', '0033', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-12 05:19:02'),
('0099', '0168', '0168-0030', 'B0021', '01', '0168-0004', 'purchaseorder', '0007', '5.0000', '5.0000', 'TECHNOZOON@gmail.com', '2021-05-13 05:49:55'),
('0100', '0168', '0168-0031', '0034', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0101', '0168', '0168-0031', '0034', '07', '0168-0004', 'count_stock', '0049', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0102', '0168', '0168-0032', '0035', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0103', '0168', '0168-0032', '0035', '07', '0168-0004', 'count_stock', '0049', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0104', '0168', '0168-0033', '0036', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0105', '0168', '0168-0033', '0036', '07', '0168-0004', 'count_stock', '0049', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0106', '0168', '0168-0034', '0037', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0107', '0168', '0168-0034', '0037', '07', '0168-0004', 'count_stock', '0049', '5.0000', '5.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0108', '0168', '0168-0030', 'B0021', '06', '0168-0004', 'cut_count_stock', '0049', '-5.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0109', '0168', '0168-0030', 'B0021', '07', '0168-0004', 'count_stock', '0049', '5.0000', '5.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0110', '0168', '0168-0029', '0033', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0111', '0168', '0168-0029', '0033', '07', '0168-0004', 'count_stock', '0049', '5.0000', '5.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0112', '0168', '0168-0037', '0040', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0113', '0168', '0168-0037', '0040', '07', '0168-0004', 'count_stock', '0049', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0114', '0168', '0168-0036', '0039', '06', '0168-0004', 'cut_count_stock', '0049', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0115', '0168', '0168-0036', '0039', '07', '0168-0004', 'count_stock', '0049', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-13 07:00:08'),
('0116', '0168', '0168-0016', 'B0009', '06', '0168-0004', 'cut_count_stock', '0068', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12'),
('0117', '0168', '0168-0016', 'B0009', '07', '0168-0004', 'count_stock', '0068', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12'),
('0118', '0168', '0168-0040', '0043', '06', '0168-0004', 'cut_count_stock', '0068', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12'),
('0119', '0168', '0168-0040', '0043', '07', '0168-0004', 'count_stock', '0068', '1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12'),
('0120', '0168', '0168-0038', '0041', '06', '0168-0004', 'cut_count_stock', '0068', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12'),
('0121', '0168', '0168-0038', '0041', '07', '0168-0004', 'count_stock', '0068', '1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:12'),
('0122', '0168', '0168-0003', 'A0003', '06', '0168-0004', 'cut_count_stock', '0058', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0123', '0168', '0168-0003', 'A0003', '07', '0168-0004', 'count_stock', '0058', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0124', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0058', '-1.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0125', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0058', '1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0126', '0168', '0168-0007', 'A0007', '06', '0168-0004', 'cut_count_stock', '0058', '-2.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0127', '0168', '0168-0007', 'A0007', '07', '0168-0004', 'count_stock', '0058', '2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0128', '0168', '0168-0005', 'A0005', '06', '0168-0004', 'cut_count_stock', '0058', '-2.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0129', '0168', '0168-0005', 'A0005', '07', '0168-0004', 'count_stock', '0058', '2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0130', '0168', '0168-0009', 'B0002', '06', '0168-0004', 'cut_count_stock', '0058', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0131', '0168', '0168-0009', 'B0002', '07', '0168-0004', 'count_stock', '0058', '1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0132', '0168', '0168-0008', 'B0001', '06', '0168-0004', 'cut_count_stock', '0058', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0133', '0168', '0168-0008', 'B0001', '07', '0168-0004', 'count_stock', '0058', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0134', '0168', '0168-0010', 'B0003', '06', '0168-0004', 'cut_count_stock', '0058', '-4.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0135', '0168', '0168-0010', 'B0003', '07', '0168-0004', 'count_stock', '0058', '4.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0136', '0168', '0168-0019', 'B0012', '06', '0168-0004', 'cut_count_stock', '0058', '-3.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0137', '0168', '0168-0019', 'B0012', '07', '0168-0004', 'count_stock', '0058', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0138', '0168', '0168-0013', 'B0006', '06', '0168-0004', 'cut_count_stock', '0058', '-6.0000', '-7.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0139', '0168', '0168-0013', 'B0006', '07', '0168-0004', 'count_stock', '0058', '5.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-13 08:21:25'),
('0140', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0034', '-1.0000', '4.0000', 'TECHNOZOON@gmail.com', '2021-05-13 09:23:50'),
('0141', '0168', '0168-0034', '0037', '02', '0168-0004', 'auth_pos_invoice', '0035', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-14 04:12:28'),
('0142', '0168', '0168-0037', '0040', '02', '0168-0004', 'auth_pos_invoice', '0038', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-15 02:59:52'),
('0143', '0168', '0168-0028', 'B0020', '02', '0168-0004', 'auth_pos_invoice', '0038', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-15 02:59:52'),
('0144', '0168', '0168-0021', 'B0013', '02', '0168-0004', 'auth_pos_invoice', '0039', '-2.0000', '6.0000', 'TECHNOZOON@gmail.com', '2021-05-17 07:39:25'),
('0145', '0168', '0168-0025', 'B0017', '02', '0168-0004', 'auth_pos_invoice', '0040', '-1.0000', '9.0000', 'TECHNOZOON@gmail.com', '2021-05-17 07:39:42'),
('0146', '0168', '0168-0028', 'B0020', '09', '0168-0004', 'return_invoice', '0041', '1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-17 07:42:47'),
('0147', '0168', '0168-0037', '0040', '09', '0168-0004', 'return_invoice', '0041', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-17 07:42:47'),
('0148', '0168', '0168-0027', 'B0019', '06', '0168-0004', 'cut_count_stock', '0072', '-3.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-17 09:00:57'),
('0149', '0168', '0168-0027', 'B0019', '07', '0168-0004', 'count_stock', '0072', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-17 09:00:57'),
('0150', '0168', '0168-0028', 'B0020', '06', '0168-0004', 'cut_count_stock', '0072', '-3.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-17 09:00:57'),
('0151', '0168', '0168-0028', 'B0020', '07', '0168-0004', 'count_stock', '0072', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-17 09:00:57'),
('0152', '0168', '0168-0016', 'B0009', '02', '0168-0004', 'auth_pos_invoice', '0042', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-21 12:34:16'),
('0153', '0168', '0168-0022', 'B0014', '01', '0168-0004', 'purchaseorder', '0008', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-22 00:53:53'),
('0154', '0168', '0168-0023', 'B0015', '01', '0168-0004', 'purchaseorder', '0008', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-22 00:53:53'),
('0155', '0168', '0168-0042', 'B0045', '01', '0168-0004', 'purchaseorder', '0008', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-22 00:53:53'),
('0156', '0168', '0168-0023', 'B0015', '02', '0168-0004', 'auth_pos_invoice', '0044', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-22 04:17:13'),
('0157', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0043', '-1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-22 04:24:54'),
('0158', '0168', '0168-0042', 'B0045', '02', '0168-0004', 'auth_pos_invoice', '0045', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-22 13:54:23'),
('0159', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0047', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-22 13:55:06'),
('0160', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0048', '-1.0000', '2.0000', 'Sale@gmail.com', '2021-05-23 01:48:03'),
('0161', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0049', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-23 03:21:52'),
('0162', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0050', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-23 03:21:56'),
('0163', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0051', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-23 03:22:09'),
('0164', '0168', '0168-0042', 'B0045', '09', '0168-0004', 'return_invoice', '0052', '1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-23 03:31:07'),
('0165', '0168', '0168-0042', 'B0045', '02', '0168-0004', 'auth_pos_invoice', '0054', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-24 13:50:21'),
('0166', '0168', '0168-0042', 'B0045', '09', '0168-0004', 'return_invoice', '0055', '1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-05-24 14:38:38'),
('0167', '0168', '0168-0028', 'B0020', '09', '0168-0004', 'return_invoice', '0056', '1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-24 14:40:27'),
('0168', '0168', '0168-0037', '0040', '09', '0168-0004', 'return_invoice', '0056', '1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-24 14:40:27'),
('0169', '0168', '0168-0029', '0033', '09', '0168-0004', 'return_invoice', '0057', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-24 14:41:29'),
('0170', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0058', '-1.0000', '1.0000', 'Sale@gmail.com', '2021-05-30 02:46:20'),
('0171', '0168', '0168-0019', 'B0012', '02', '0168-0004', 'auth_pos_invoice', '0060', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-30 13:04:13'),
('0172', '0168', '0168-0023', 'B0015', '02', '0168-0004', 'auth_pos_invoice', '0059', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-30 13:04:19'),
('0173', '0168', '0168-0042', 'B0045', '02', '0168-0008', 'auth_pos_invoice', '0061', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:47:35'),
('0174', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0062', '-1.0000', '9.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:47:48'),
('0175', '0168', '0168-0031', '0034', '06', '0168-0004', 'cut_count_stock', '0075', '-10.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35'),
('0176', '0168', '0168-0031', '0034', '07', '0168-0004', 'count_stock', '0075', '0.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35'),
('0177', '0168', '0168-0032', '0035', '06', '0168-0004', 'cut_count_stock', '0075', '-10.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35'),
('0178', '0168', '0168-0032', '0035', '07', '0168-0004', 'count_stock', '0075', '0.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35'),
('0179', '0168', '0168-0033', '0036', '06', '0168-0004', 'cut_count_stock', '0075', '-10.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35'),
('0180', '0168', '0168-0033', '0036', '07', '0168-0004', 'count_stock', '0075', '0.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-05-31 03:50:35'),
('0181', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0063', '-1.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 04:27:14'),
('0182', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0064', '-1.0000', '-1.0000', 'Sale@gmail.com', '2021-05-31 04:32:29'),
('0183', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0065', '-1.0000', '8.0000', 'TECHNOZOON@gmail.com', '2021-05-31 06:45:38'),
('0184', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0066', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-05-31 06:45:44'),
('0185', '0168', '0168-0042', 'B0045', '09', '0168-0004', 'return_invoice', '0067', '1.0000', '4.0000', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:20'),
('0186', '0168', '0168-0022', 'B0014', '09', '0168-0004', 'return_invoice', '0070', '1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:24'),
('0187', '0168', '0168-0022', 'B0014', '09', '0168-0004', 'return_invoice', '0069', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:28'),
('0188', '0168', '0168-0024', 'B0016', '09', '0168-0004', 'return_invoice', '0068', '1.0000', '9.0000', 'TECHNOZOON@gmail.com', '2021-05-31 07:08:32'),
('0189', '0168', '0168-0019', 'B0012', '06', '0168-0004', 'cut_count_stock', '0079', '-1.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0190', '0168', '0168-0019', 'B0012', '07', '0168-0004', 'count_stock', '0079', '1.0000', '1.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0191', '0168', '0168-0022', 'B0014', '06', '0168-0004', 'cut_count_stock', '0079', '0.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0192', '0168', '0168-0022', 'B0014', '07', '0168-0004', 'count_stock', '0079', '1.0000', '1.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0193', '0168', '0168-0036', '0039', '06', '0168-0004', 'cut_count_stock', '0079', '-3.0000', '-3.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0194', '0168', '0168-0036', '0039', '07', '0168-0004', 'count_stock', '0079', '3.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0195', '0168', '0168-0037', '0040', '06', '0168-0004', 'cut_count_stock', '0079', '-4.0000', '-3.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0196', '0168', '0168-0037', '0040', '07', '0168-0004', 'count_stock', '0079', '3.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0197', '0168', '0168-0021', 'B0013', '06', '0168-0004', 'cut_count_stock', '0079', '-6.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0198', '0168', '0168-0021', 'B0013', '07', '0168-0004', 'count_stock', '0079', '4.0000', '4.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0199', '0168', '0168-0024', 'B0016', '06', '0168-0004', 'cut_count_stock', '0079', '-9.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0200', '0168', '0168-0024', 'B0016', '07', '0168-0004', 'count_stock', '0079', '7.0000', '7.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0201', '0168', '0168-0025', 'B0017', '06', '0168-0004', 'cut_count_stock', '0079', '-9.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0202', '0168', '0168-0025', 'B0017', '07', '0168-0004', 'count_stock', '0079', '9.0000', '9.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0203', '0168', '0168-0026', 'B0018', '06', '0168-0004', 'cut_count_stock', '0079', '-10.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0204', '0168', '0168-0026', 'B0018', '07', '0168-0004', 'count_stock', '0079', '10.0000', '10.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0205', '0168', '0168-0042', 'B0045', '06', '0168-0004', 'cut_count_stock', '0079', '-4.0000', '0.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0206', '0168', '0168-0042', 'B0045', '07', '0168-0004', 'count_stock', '0079', '2.0000', '2.0000', 'Sale@gmail.com', '2021-05-31 09:16:05'),
('0207', '0168', '0168-0029', '0033', '09', '0168-0004', 'return_invoice', '0071', '1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-05-31 09:16:52'),
('0208', '0168', '0168-0030', 'B0021', '02', '0168-0004', 'auth_pos_invoice', '0072', '-1.0000', '4.0000', 'TECHNOZOON@gmail.com', '2021-05-31 09:17:48'),
('0209', '0168', '0168-0028', 'B0020', '06', '0168-0004', 'cut_count_stock', '0089', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-31 09:22:00'),
('0210', '0168', '0168-0028', 'B0020', '07', '0168-0004', 'count_stock', '0089', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-05-31 09:22:00'),
('0211', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0073', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-06 13:11:35'),
('0212', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0074', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-08 02:46:41'),
('0213', '0168', '0168-0019', 'B0012', '02', '0168-0004', 'auth_pos_invoice', '0075', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-11 04:37:35'),
('0214', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0076', '-1.0000', '-11.0000', 'TECHNOZOON@gmail.com', '2021-06-11 04:37:42'),
('0215', '0168', '0168-0025', 'B0017', '02', '0168-0004', 'auth_pos_invoice', '0077', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-11 04:37:50'),
('0216', '0168', '0168-0025', 'B0017', '02', '0168-0004', 'auth_pos_invoice', '0078', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-11 05:41:08'),
('0217', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0079', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-12 13:42:37'),
('0218', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0080', '-1.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-06-13 07:05:56'),
('0219', '0168', '0168-0025', 'B0017', '02', '0168-0004', 'auth_pos_invoice', '0080', '-1.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-06-13 07:05:56'),
('0220', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0081', '-1.0000', '-1.0000', 'Sale@gmail.com', '2021-06-16 08:24:20'),
('0221', '0168', '0168-0030', 'B0021', '02', '0168-0004', 'auth_pos_invoice', '0082', '-1.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-06-21 07:37:53'),
('0222', '0168', '0168-0033', '0036', '02', '0168-0004', 'auth_pos_invoice', '0084', '-1.0000', '-11.0000', 'TECHNOZOON@gmail.com', '2021-06-26 02:53:21'),
('0223', '0168', '0168-0033', '0036', '02', '0168-0004', 'auth_pos_invoice', '0085', '-1.0000', '-12.0000', 'TECHNOZOON@gmail.com', '2021-06-26 08:05:35'),
('0224', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0086', '-1.0000', '-4.0000', 'TECHNOZOON@gmail.com', '2021-06-28 03:45:33'),
('0225', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0087', '-1.0000', '-5.0000', 'TECHNOZOON@gmail.com', '2021-06-30 07:51:02'),
('0226', '0168', '0168-0032', '0035', '06', '0168-0004', 'cut_count_stock', '0091', '1.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-06-30 08:48:00'),
('0227', '0168', '0168-0032', '0035', '07', '0168-0004', 'count_stock', '0091', '0.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-06-30 08:48:00'),
('0228', '0168', '0168-0033', '0036', '06', '0168-0004', 'cut_count_stock', '0091', '2.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-06-30 08:48:00'),
('0229', '0168', '0168-0033', '0036', '07', '0168-0004', 'count_stock', '0091', '0.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-06-30 08:48:00'),
('0230', '0168', '0168-0003', 'A0003', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0231', '0168', '0168-0003', 'A0003', '07', '0168-0004', 'count_stock', '0094', '1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0232', '0168', '0168-0004', 'A0004', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0233', '0168', '0168-0004', 'A0004', '07', '0168-0004', 'count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0234', '0168', '0168-0005', 'A0005', '06', '0168-0004', 'cut_count_stock', '0094', '-2.0000', '-4.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0235', '0168', '0168-0005', 'A0005', '07', '0168-0004', 'count_stock', '0094', '2.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0236', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0237', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0094', '1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0238', '0168', '0168-0007', 'A0007', '06', '0168-0004', 'cut_count_stock', '0094', '-2.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0239', '0168', '0168-0007', 'A0007', '07', '0168-0004', 'count_stock', '0094', '2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0240', '0168', '0168-0008', 'B0001', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0241', '0168', '0168-0008', 'B0001', '07', '0168-0004', 'count_stock', '0094', '1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0242', '0168', '0168-0009', 'B0002', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0243', '0168', '0168-0009', 'B0002', '07', '0168-0004', 'count_stock', '0094', '1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0244', '0168', '0168-0010', 'B0003', '06', '0168-0004', 'cut_count_stock', '0094', '-4.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0245', '0168', '0168-0010', 'B0003', '07', '0168-0004', 'count_stock', '0094', '4.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0246', '0168', '0168-0011', 'B0004', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0247', '0168', '0168-0011', 'B0004', '07', '0168-0004', 'count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0248', '0168', '0168-0013', 'B0006', '06', '0168-0004', 'cut_count_stock', '0094', '-5.0000', '-7.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0249', '0168', '0168-0013', 'B0006', '07', '0168-0004', 'count_stock', '0094', '5.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0250', '0168', '0168-0014', 'B0007', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0251', '0168', '0168-0014', 'B0007', '07', '0168-0004', 'count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0252', '0168', '0168-0021', 'B0013', '06', '0168-0004', 'cut_count_stock', '0094', '-4.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0253', '0168', '0168-0021', 'B0013', '07', '0168-0004', 'count_stock', '0094', '6.0000', '6.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0254', '0168', '0168-0022', 'B0014', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0255', '0168', '0168-0022', 'B0014', '07', '0168-0004', 'count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0256', '0168', '0168-0024', 'B0016', '06', '0168-0004', 'cut_count_stock', '0094', '-2.0000', '-7.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0257', '0168', '0168-0024', 'B0016', '07', '0168-0004', 'count_stock', '0094', '4.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0258', '0168', '0168-0025', 'B0017', '06', '0168-0004', 'cut_count_stock', '0094', '-6.0000', '-9.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0259', '0168', '0168-0025', 'B0017', '07', '0168-0004', 'count_stock', '0094', '4.0000', '-5.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0260', '0168', '0168-0026', 'B0018', '06', '0168-0004', 'cut_count_stock', '0094', '-10.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0261', '0168', '0168-0026', 'B0018', '07', '0168-0004', 'count_stock', '0094', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0262', '0168', '0168-0029', '0033', '06', '0168-0004', 'cut_count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0263', '0168', '0168-0029', '0033', '07', '0168-0004', 'count_stock', '0094', '7.0000', '7.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0264', '0168', '0168-0035', '0038', '06', '0168-0004', 'cut_count_stock', '0094', '0.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0265', '0168', '0168-0035', '0038', '07', '0168-0004', 'count_stock', '0094', '3.0000', '3.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0266', '0168', '0168-0034', '0037', '06', '0168-0004', 'cut_count_stock', '0094', '-4.0000', '-5.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0267', '0168', '0168-0034', '0037', '07', '0168-0004', 'count_stock', '0094', '4.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0268', '0168', '0168-0036', '0039', '06', '0168-0004', 'cut_count_stock', '0094', '-3.0000', '-6.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0269', '0168', '0168-0036', '0039', '07', '0168-0004', 'count_stock', '0094', '3.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0270', '0168', '0168-0037', '0040', '06', '0168-0004', 'cut_count_stock', '0094', '-3.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0271', '0168', '0168-0037', '0040', '07', '0168-0004', 'count_stock', '0094', '3.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0272', '0168', '0168-0040', '0043', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0273', '0168', '0168-0040', '0043', '07', '0168-0004', 'count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0274', '0168', '0168-0038', '0041', '06', '0168-0004', 'cut_count_stock', '0094', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0275', '0168', '0168-0038', '0041', '07', '0168-0004', 'count_stock', '0094', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0276', '0168', '0168-0042', 'B0045', '06', '0168-0004', 'cut_count_stock', '0094', '-2.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0277', '0168', '0168-0042', 'B0045', '07', '0168-0004', 'count_stock', '0094', '2.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-06-30 09:17:02'),
('0278', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0088', '-1.0000', '-8.0000', 'TECHNOZOON@gmail.com', '2021-07-02 14:25:20'),
('0279', '0168', '0168-0030', 'B0021', '02', '0168-0004', 'auth_pos_invoice', '0089', '-1.0000', '2.0000', 'TECHNOZOON@gmail.com', '2021-07-02 14:25:29'),
('0280', '0168', '0168-0030', 'B0021', '02', '0168-0004', 'auth_pos_invoice', '0090', '-1.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-07-08 04:01:31'),
('0281', '0168', '0168-0035', '0038', '06', '0168-0004', 'cut_count_stock', '0119', '-3.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-07-08 04:04:17'),
('0282', '0168', '0168-0035', '0038', '07', '0168-0004', 'count_stock', '0119', '0.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-07-08 04:04:17'),
('0283', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0091', '-1.0000', '-9.0000', 'Sale@gmail.com', '2021-07-10 03:57:39'),
('0284', '0168', '0168-0003', 'A0003', '02', '0168-0004', 'auth_pos_invoice', '0092', '-1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-10 03:58:32'),
('0285', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0093', '-1.0000', '-10.0000', 'TECHNOZOON@gmail.com', '2021-07-12 02:12:31'),
('0286', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0094', '-2.0000', '-12.0000', 'TECHNOZOON@gmail.com', '2021-07-12 02:12:34');
INSERT INTO `pos_tbl_transactions` (`sysdocnum`, `branchcode`, `pro_code`, `pro_barcode`, `trancode`, `stockcode`, `trn_status`, `trn_ref`, `trn_qty`, `trn_qty_tt`, `inputter`, `inputdate`) VALUES
('0287', '0168', '0168-0037', '0040', '02', '0168-0004', 'auth_pos_invoice', '0095', '-1.0000', '-4.0000', 'TECHNOZOON@gmail.com', '2021-07-12 02:12:40'),
('0288', '0168', '0168-0036', '0039', '02', '0168-0004', 'auth_pos_invoice', '0096', '-1.0000', '-4.0000', 'TECHNOZOON@gmail.com', '2021-07-12 03:01:00'),
('0289', '0168', '0168-0024', 'B0016', '06', '0168-0004', 'cut_count_stock', '0121', '1.0000', '-11.0000', 'TECHNOZOON@gmail.com', '2021-07-13 03:16:04'),
('0290', '0168', '0168-0024', 'B0016', '07', '0168-0004', 'count_stock', '0121', '0.0000', '-11.0000', 'TECHNOZOON@gmail.com', '2021-07-13 03:16:04'),
('0291', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0098', '-1.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-07-13 07:52:32'),
('0292', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0100', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-07-16 13:10:22'),
('0293', '0168', '0168-0030', 'B0021', '02', '0168-0004', 'auth_pos_invoice', '0100', '-1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-07-16 13:10:22'),
('0294', '0168', '0168-0024', 'B0016', '01', '0168-0004', 'purchaseorder', '0009', '10.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-07-20 06:21:11'),
('0295', '0168', '0168-0025', 'B0017', '01', '0168-0004', 'purchaseorder', '0009', '10.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-07-20 06:21:11'),
('0296', '0168', '0168-0043', 'B0046', '01', '0168-0004', 'purchaseorder', '0010', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-07-20 06:23:37'),
('0297', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0102', '-1.0000', '-11.0000', 'TECHNOZOON@gmail.com', '2021-07-20 07:03:52'),
('0298', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0103', '-2.0000', '-3.0000', 'TECHNOZOON@gmail.com', '2021-07-21 08:53:57'),
('0299', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0105', '-1.0000', '-12.0000', 'TECHNOZOON@gmail.com', '2021-07-22 08:29:07'),
('0300', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0106', '-1.0000', '-4.0000', 'TECHNOZOON@gmail.com', '2021-07-29 05:47:57'),
('0301', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0107', '-1.0000', '-5.0000', 'TECHNOZOON@gmail.com', '2021-07-30 12:30:29'),
('0302', '0168', '0168-0029', '0033', '06', '0168-0004', 'cut_count_stock', '0123', '-5.0000', '-7.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0303', '0168', '0168-0029', '0033', '07', '0168-0004', 'count_stock', '0123', '5.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0304', '0168', '0168-0034', '0037', '06', '0168-0004', 'cut_count_stock', '0123', '-4.0000', '-5.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0305', '0168', '0168-0034', '0037', '07', '0168-0004', 'count_stock', '0123', '4.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0306', '0168', '0168-0043', 'B0046', '06', '0168-0004', 'cut_count_stock', '0123', '-10.0000', '0.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0307', '0168', '0168-0043', 'B0046', '07', '0168-0004', 'count_stock', '0123', '10.0000', '10.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0308', '0168', '0168-0022', 'B0014', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0309', '0168', '0168-0022', 'B0014', '07', '0168-0004', 'count_stock', '0123', '1.0000', '0.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0310', '0168', '0168-0023', 'B0015', '06', '0168-0004', 'cut_count_stock', '0123', '0.0000', '0.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0311', '0168', '0168-0023', 'B0015', '07', '0168-0004', 'count_stock', '0123', '2.0000', '2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0312', '0168', '0168-0036', '0039', '06', '0168-0004', 'cut_count_stock', '0123', '-2.0000', '-6.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0313', '0168', '0168-0036', '0039', '07', '0168-0004', 'count_stock', '0123', '2.0000', '-4.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0314', '0168', '0168-0037', '0040', '06', '0168-0004', 'cut_count_stock', '0123', '-2.0000', '-6.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0315', '0168', '0168-0037', '0040', '07', '0168-0004', 'count_stock', '0123', '2.0000', '-4.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0316', '0168', '0168-0021', 'B0013', '06', '0168-0004', 'cut_count_stock', '0123', '-6.0000', '-6.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0317', '0168', '0168-0021', 'B0013', '07', '0168-0004', 'count_stock', '0123', '6.0000', '0.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0318', '0168', '0168-0005', 'A0005', '06', '0168-0004', 'cut_count_stock', '0123', '-2.0000', '-4.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0319', '0168', '0168-0005', 'A0005', '07', '0168-0004', 'count_stock', '0123', '2.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0320', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-4.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0321', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-3.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0322', '0168', '0168-0007', 'A0007', '06', '0168-0004', 'cut_count_stock', '0123', '-2.0000', '-4.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0323', '0168', '0168-0007', 'A0007', '07', '0168-0004', 'count_stock', '0123', '2.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0324', '0168', '0168-0024', 'B0016', '06', '0168-0004', 'cut_count_stock', '0123', '-6.0000', '-11.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0325', '0168', '0168-0024', 'B0016', '07', '0168-0004', 'count_stock', '0123', '7.0000', '-4.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0326', '0168', '0168-0026', 'B0018', '06', '0168-0004', 'cut_count_stock', '0123', '-10.0000', '-10.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0327', '0168', '0168-0026', 'B0018', '07', '0168-0004', 'count_stock', '0123', '8.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0328', '0168', '0168-0013', 'B0006', '06', '0168-0004', 'cut_count_stock', '0123', '-5.0000', '-12.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0329', '0168', '0168-0013', 'B0006', '07', '0168-0004', 'count_stock', '0123', '5.0000', '-7.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0330', '0168', '0168-0014', 'B0007', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0331', '0168', '0168-0014', 'B0007', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0332', '0168', '0168-0038', '0041', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0333', '0168', '0168-0038', '0041', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0334', '0168', '0168-0010', 'B0003', '06', '0168-0004', 'cut_count_stock', '0123', '-4.0000', '-5.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0335', '0168', '0168-0010', 'B0003', '07', '0168-0004', 'count_stock', '0123', '4.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0336', '0168', '0168-0004', 'A0004', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0337', '0168', '0168-0004', 'A0004', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0338', '0168', '0168-0008', 'B0001', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0339', '0168', '0168-0008', 'B0001', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0340', '0168', '0168-0009', 'B0002', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-3.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0341', '0168', '0168-0009', 'B0002', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0342', '0168', '0168-0011', 'B0004', '06', '0168-0004', 'cut_count_stock', '0123', '-1.0000', '-2.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0343', '0168', '0168-0011', 'B0004', '07', '0168-0004', 'count_stock', '0123', '1.0000', '-1.0000', 'Sale@gmail.com', '2021-07-31 03:21:44'),
('0344', '0168', '0168-0030', 'B0021', '01', '0168-0004', 'purchaseorder', '0011', '10.0000', '10.0000', 'TECHNOZOON@gmail.com', '2021-08-04 09:47:57'),
('0345', '0168', '0168-0029', '0033', '01', '0168-0004', 'purchaseorder', '0011', '3.0000', '1.0000', 'TECHNOZOON@gmail.com', '2021-08-04 09:47:57'),
('0346', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0108', '-1.0000', '-12.0000', 'TECHNOZOON@gmail.com', '2021-08-04 10:02:56'),
('0347', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0109', '-1.0000', '-13.0000', 'TECHNOZOON@gmail.com', '2021-08-05 05:55:40'),
('0348', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0111', '-1.0000', '-14.0000', 'TECHNOZOON@gmail.com', '2021-08-12 10:55:49'),
('0349', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0112', '-2.0000', '-1.0000', 'TECHNOZOON@gmail.com', '2021-08-12 10:55:55'),
('0350', '0168', '0168-0010', 'B0003', '02', '0168-0004', 'auth_pos_invoice', '0113', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-08-12 10:55:59'),
('0351', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0114', '-1.0000', '-15.0000', 'TECHNOZOON@gmail.com', '2021-08-12 10:56:02'),
('0352', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0115', '-1.0000', '-13.0000', 'TECHNOZOON@gmail.com', '2021-08-12 10:56:42'),
('0353', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0116', '-2.0000', '-17.0000', 'TECHNOZOON@gmail.com', '2021-08-16 01:15:19'),
('0354', '0168', '0168-0011', 'B0004', '04', '0168-0004', 'f_stocktransfer', '0008', '-1.0000', '-2.0000', 'TECHNOZOON@gmail.com', '2021-08-16 10:54:31'),
('0355', '0168', '0168-0011', 'B0004', '03', '0168-0003', 't_stocktransfer', '0008', '1.0000', '0.0000', 'TECHNOZOON@gmail.com', '2021-08-16 10:54:31'),
('0356', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0117', '-1.0000', '-18.0000', 'TECHNOZOON@gmail.com', '2021-08-18 04:15:17'),
('0357', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0123', '-1.0000', '-14.0000', 'technozoon@gmail.com', '2021-08-21 09:28:11'),
('0358', '0168', '0168-0043', 'B0046', '02', '0168-0004', 'auth_pos_invoice', '0122', '-1.0000', '9.0000', 'technozoon@gmail.com', '2021-08-21 09:28:17'),
('0359', '0168', '0168-0022', 'B0014', '02', '0168-0004', 'auth_pos_invoice', '0121', '-1.0000', '-2.0000', 'technozoon@gmail.com', '2021-08-21 09:28:27'),
('0360', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0124', '-1.0000', '-15.0000', 'technozoon@gmail.com', '2021-08-26 03:00:53'),
('0361', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0125', '-1.0000', '-16.0000', 'technozoon@gmail.com', '2021-08-26 03:01:00'),
('0362', '0168', '0168-0010', 'B0003', '02', '0168-0004', 'auth_pos_invoice', '0126', '-1.0000', '-3.0000', 'technozoon@gmail.com', '2021-08-26 03:01:17'),
('0363', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0127', '-1.0000', '-19.0000', 'technozoon@gmail.com', '2021-08-27 13:44:00'),
('0364', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0128', '-1.0000', '-20.0000', 'technozoon@gmail.com', '2021-08-27 13:54:48'),
('0365', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0129', '-1.0000', '-21.0000', 'technozoon@gmail.com', '2021-08-30 00:47:29'),
('0366', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0130', '-1.0000', '-22.0000', 'technozoon@gmail.com', '2021-08-30 00:47:35'),
('0367', '0168', '0168-0024', 'B0016', '01', '0168-0004', 'purchaseorder', '0012', '20.0000', '-2.0000', 'technozoon@gmail.com', '2021-08-30 01:35:56'),
('0368', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0135', '-1.0000', '-3.0000', 'technozoon@gmail.com', '2021-08-31 06:31:20'),
('0369', '0168', '0168-0029', '0033', '02', '0168-0004', 'auth_pos_invoice', '0134', '-1.0000', '-2.0000', 'technozoon@gmail.com', '2021-08-31 06:31:35'),
('0370', '0168', '0168-0035', '0038', '02', '0168-0004', 'auth_pos_invoice', '0133', '-1.0000', '-4.0000', 'technozoon@gmail.com', '2021-08-31 06:31:42'),
('0371', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0132', '-1.0000', '-4.0000', 'technozoon@gmail.com', '2021-08-31 06:31:57'),
('0372', '0168', '0168-0032', '0035', '02', '0168-0004', 'auth_pos_invoice', '0131', '-1.0000', '-17.0000', 'technozoon@gmail.com', '2021-08-31 06:32:37'),
('0373', '0168', '0168-0032', '0035', '06', '0168-0004', 'cut_count_stock', '0145', '7.0000', '-10.0000', 'technozoon@gmail.com', '2021-09-01 01:40:49'),
('0374', '0168', '0168-0032', '0035', '07', '0168-0004', 'count_stock', '0145', '0.0000', '-10.0000', 'technozoon@gmail.com', '2021-09-01 01:40:49'),
('0375', '0168', '0168-0026', 'B0018', '06', '0168-0004', 'cut_count_stock', '0147', '-8.0000', '-10.0000', 'technozoon@gmail.com', '2021-09-01 01:44:29'),
('0376', '0168', '0168-0026', 'B0018', '07', '0168-0004', 'count_stock', '0147', '2.0000', '-8.0000', 'technozoon@gmail.com', '2021-09-01 01:44:29'),
('0377', '0168', '0168-0035', '0038', '06', '0168-0004', 'cut_count_stock', '0149', '1.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 01:48:16'),
('0378', '0168', '0168-0035', '0038', '07', '0168-0004', 'count_stock', '0149', '0.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 01:48:16'),
('0379', '0168', '0168-0030', 'B0021', '06', '0168-0004', 'cut_count_stock', '0153', '-10.0000', '0.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0380', '0168', '0168-0030', 'B0021', '07', '0168-0004', 'count_stock', '0153', '9.0000', '9.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0381', '0168', '0168-0034', '0037', '06', '0168-0004', 'cut_count_stock', '0153', '-4.0000', '-9.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0382', '0168', '0168-0034', '0037', '07', '0168-0004', 'count_stock', '0153', '4.0000', '-5.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0383', '0168', '0168-0019', 'B0012', '06', '0168-0004', 'cut_count_stock', '0153', '0.0000', '0.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0384', '0168', '0168-0019', 'B0012', '07', '0168-0004', 'count_stock', '0153', '1.0000', '1.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0385', '0168', '0168-0013', 'B0006', '06', '0168-0004', 'cut_count_stock', '0153', '-5.0000', '-12.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0386', '0168', '0168-0013', 'B0006', '07', '0168-0004', 'count_stock', '0153', '4.0000', '-8.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0387', '0168', '0168-0040', '0043', '06', '0168-0004', 'cut_count_stock', '0153', '-1.0000', '-2.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0388', '0168', '0168-0040', '0043', '07', '0168-0004', 'count_stock', '0153', '1.0000', '-1.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0389', '0168', '0168-0038', '0041', '06', '0168-0004', 'cut_count_stock', '0153', '-1.0000', '-2.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0390', '0168', '0168-0038', '0041', '07', '0168-0004', 'count_stock', '0153', '1.0000', '-1.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0391', '0168', '0168-0029', '0033', '06', '0168-0004', 'cut_count_stock', '0153', '-5.0000', '-7.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0392', '0168', '0168-0029', '0033', '07', '0168-0004', 'count_stock', '0153', '4.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0393', '0168', '0168-0024', 'B0016', '06', '0168-0004', 'cut_count_stock', '0153', '-14.0000', '-18.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0394', '0168', '0168-0024', 'B0016', '07', '0168-0004', 'count_stock', '0153', '13.0000', '-5.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0395', '0168', '0168-0026', 'B0018', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-10.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0396', '0168', '0168-0026', 'B0018', '07', '0168-0004', 'count_stock', '0153', '3.0000', '-7.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0397', '0168', '0168-0025', 'B0017', '06', '0168-0004', 'cut_count_stock', '0153', '-14.0000', '-13.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0398', '0168', '0168-0025', 'B0017', '07', '0168-0004', 'count_stock', '0153', '4.0000', '-9.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0399', '0168', '0168-0005', 'A0005', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-6.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0400', '0168', '0168-0005', 'A0005', '07', '0168-0004', 'count_stock', '0153', '2.0000', '-4.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0401', '0168', '0168-0006', 'A0006', '06', '0168-0004', 'cut_count_stock', '0153', '-1.0000', '-4.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0402', '0168', '0168-0006', 'A0006', '07', '0168-0004', 'count_stock', '0153', '1.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0403', '0168', '0168-0007', 'A0007', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-4.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0404', '0168', '0168-0007', 'A0007', '07', '0168-0004', 'count_stock', '0153', '2.0000', '-2.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0405', '0168', '0168-0021', 'B0013', '06', '0168-0004', 'cut_count_stock', '0153', '-6.0000', '-6.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0406', '0168', '0168-0021', 'B0013', '07', '0168-0004', 'count_stock', '0153', '5.0000', '-1.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0407', '0168', '0168-0042', 'B0045', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-2.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0408', '0168', '0168-0042', 'B0045', '07', '0168-0004', 'count_stock', '0153', '2.0000', '0.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0409', '0168', '0168-0010', 'B0003', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-5.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0410', '0168', '0168-0010', 'B0003', '07', '0168-0004', 'count_stock', '0153', '2.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0411', '0168', '0168-0008', 'B0001', '06', '0168-0004', 'cut_count_stock', '0153', '-1.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0412', '0168', '0168-0008', 'B0001', '07', '0168-0004', 'count_stock', '0153', '1.0000', '-2.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0413', '0168', '0168-0009', 'B0002', '06', '0168-0004', 'cut_count_stock', '0153', '-1.0000', '-3.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0414', '0168', '0168-0009', 'B0002', '07', '0168-0004', 'count_stock', '0153', '1.0000', '-2.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0415', '0168', '0168-0036', '0039', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-6.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0416', '0168', '0168-0036', '0039', '07', '0168-0004', 'count_stock', '0153', '2.0000', '-4.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0417', '0168', '0168-0037', '0040', '06', '0168-0004', 'cut_count_stock', '0153', '-2.0000', '-8.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0418', '0168', '0168-0037', '0040', '07', '0168-0004', 'count_stock', '0153', '2.0000', '-6.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0419', '0168', '0168-0044', 'B00047', '06', '0168-0004', 'cut_count_stock', '0153', '0.0000', '0.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0420', '0168', '0168-0044', 'B00047', '07', '0168-0004', 'count_stock', '0153', '1.0000', '1.0000', 'technozoon@gmail.com', '2021-09-01 14:14:06'),
('0421', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0136', '-2.0000', '-20.0000', 'technozoon@gmail.com', '2021-09-06 06:17:36'),
('0422', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0137', '-1.0000', '-21.0000', 'technozoon@gmail.com', '2021-09-06 06:17:56'),
('0423', '0168', '0168-0045', 'B0048', '02', '0168-0004', 'auth_pos_invoice', '0138', '-1.0000', '-1.0000', 'technozoon@gmail.com', '2021-09-06 06:18:28'),
('0424', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0139', '-1.0000', '-22.0000', 'technozoon@gmail.com', '2021-09-06 06:18:44'),
('0425', '0168', '0168-0042', 'B0045', '02', '0168-0004', 'auth_pos_invoice', '0140', '-1.0000', '-1.0000', 'technozoon@gmail.com', '2021-09-06 06:19:40'),
('0426', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0141', '-2.0000', '-24.0000', 'technozoon@gmail.com', '2021-09-06 06:19:59'),
('0427', '0168', '0168-0034', '0037', '02', '0168-0004', 'auth_pos_invoice', '0142', '-1.0000', '-6.0000', 'technozoon@gmail.com', '2021-09-07 05:48:46'),
('0428', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0143', '-1.0000', '-25.0000', 'technozoon@gmail.com', '2021-09-07 05:48:56'),
('0429', '0168', '0168-0025', 'B0017', '02', '0168-0004', 'auth_pos_invoice', '0144', '-1.0000', '-14.0000', 'technozoon@gmail.com', '2021-09-07 05:49:30'),
('0430', '0168', '0168-0024', 'B0016', '02', '0168-0004', 'auth_pos_invoice', '0145', '-1.0000', '-26.0000', 'technozoon@gmail.com', '2021-09-07 05:49:40');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_count_stock`
--

CREATE TABLE `pos_tbl_una_count_stock` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `stockcode` varchar(20) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_count_stock`
--

INSERT INTO `pos_tbl_una_count_stock` (`tran_code`, `branchcode`, `stockcode`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `sys_token`) VALUES
('0177', '0168', '0168-0004', NULL, 'sale@gmail.com', '2021-09-03 23:55:36', NULL, NULL, '0168-6132b5f87d511');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_count_stock_detail`
--

CREATE TABLE `pos_tbl_una_count_stock_detail` (
  `sysdocnum` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `tran_code` varchar(20) DEFAULT NULL,
  `pro_code` varchar(20) DEFAULT NULL,
  `barcode` varchar(20) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_count_stock_detail`
--

INSERT INTO `pos_tbl_una_count_stock_detail` (`sysdocnum`, `branchcode`, `tran_code`, `pro_code`, `barcode`, `qty`) VALUES
('0178', '0168', '0177', '0168-0045', '0048', '9.00'),
('0179', '0168', '0177', '0168-0046', '0049', '3.00'),
('0180', '0168', '0177', '0168-0047', '0050', '10.00'),
('0181', '0168', '0177', '0168-0048', '0051', '4.00');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_document_file`
--

CREATE TABLE `pos_tbl_una_document_file` (
  `sysdonum` varchar(20) NOT NULL,
  `trancode` varchar(20) DEFAULT NULL,
  `branchcode` varchar(20) NOT NULL,
  `file_path` varchar(250) DEFAULT NULL,
  `file_name` varchar(250) DEFAULT NULL,
  `org_name` varchar(250) DEFAULT NULL,
  `file_ext` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_document_file`
--

INSERT INTO `pos_tbl_una_document_file` (`sysdonum`, `trancode`, `branchcode`, `file_path`, `file_name`, `org_name`, `file_ext`, `status`, `inputter`, `inputdate`) VALUES
('0168-0001', '0168-0012', '0168', 'pos/expense/', '0168-161763419830.jpg', 'bootstrap-tabs.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 14:49:58'),
('0168-0002', '0168-0013', '0168', 'pos/expense/', '0168-16176342487.jpg', 'bootstrap-contact-forms.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 14:50:48'),
('0168-0003', '0168-0013', '0168', 'pos/expense/', '0168-161763424811.png', 'Screen Shot 2021-04-01 at 1.38.24 PM.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 14:50:48'),
('0168-0004', '0168-0014', '0168', 'app/pos/expense/', '0168-161763435475.jpg', 'bootstrap-tabs.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 14:52:34'),
('0168-0005', '0168-0015', '0168', 'app/pos/expense/', '0168-161763487264.jpg', 'bootstrap-tabs.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 15:01:12'),
('0168-0006', '0168-0020', '0168', 'pos/expense/', '0168-161763535457.png', '02.04.21(2)-1.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 15:09:14'),
('0168-0007', '0168-0020', '0168', 'pos/expense/', '0168-161763535453.jpg', 'bootstrap-contact-forms.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 15:09:14'),
('0168-0008', '0168-0022', '0168', 'pos/expense/', '0168-161763545571.jpg', 'bootstrap-tabs.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 15:10:55'),
('0168-0009', '0168-0022', '0168', 'pos/expense/', '0168-16176354559.png', '02.04.21(2)-1.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 15:10:55'),
('0168-0010', '0168-0022', '0168', 'pos/expense/', '0168-161763545578.png', '166711278_3672060702904368_5200771555067879610_n.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-05 15:10:55'),
('0168-0011', '0168-0023', '0168', 'pos/expense/', '0168-161769216127.jpg', '9ad16d075e7007f9e2e85d38d4abe27e.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 06:56:01'),
('0168-0012', '0168-0023', '0168', 'pos/expense/', '0168-161769216148.png', '02.04.21(2)-1.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 06:56:01'),
('0168-0013', '0168-0024', '0168', 'pos/income', '0168-161769239784.jpg', 'bootstrap-contact-forms.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-06 06:59:57'),
('0168-0014', '0168-0024', '0168', 'pos/income', '0168-161769239717.jpg', '155406543_106287778184730_7287232708214648603_o.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-06 06:59:57'),
('0168-0015', '0168-0025', '0168', 'pos/expense/', '0168-161769520990.jpg', 'Capture-price_large.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 07:46:49'),
('0168-0016', '0168-0025', '0168', 'pos/expense/', '0168-161769520959.jpg', '9ad16d075e7007f9e2e85d38d4abe27e.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 07:46:49'),
('0168-0017', '0168-0026', '0168', 'pos/income', '0168-161769527758.jpg', 'bootstrap-contact-forms.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-06 07:47:57'),
('0168-0018', '0168-0026', '0168', 'pos/income', '0168-16176952775.jpg', 'creative-editable-sale-tag-with-empty-abstract-background_75010-29.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-06 07:47:57'),
('0168-0019', '0168-0026', '0168', 'pos/income', '0168-161769527712.jpg', 'f246ca9bd3d67ccc9b2e6f0f25d71248.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-06 07:47:57'),
('0168-0020', '0168-0027', '0168', 'pos/expense/', '0168-161769542452.jpg', '0F6BC5E5-42CC-44B8-A2FD-3612935EDEEF.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-06 07:50:24'),
('0168-0028', '0168-0032', '0168', 'pos/income', '0168-161785186420.jpg', 'photo_2021-04-08_10-02-21.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-08 03:17:44'),
('0168-0029', '0168-0032', '0168', 'pos/income', '0168-161785186470.jpg', 'photo_2021-04-08_10-14-24.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-08 03:17:44'),
('0168-0033', '0168-0035', '0168', 'pos/expense/', '0168-161793722435.jpg', 'photo_2021-04-09_09-30-17 (2).jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:00:24'),
('0168-0034', '0168-0035', '0168', 'pos/expense/', '0168-161793722449.jpg', 'photo_2021-04-09_09-30-17.jpg', '.jpg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-09 03:00:24'),
('0168-0041', '0168-0039', '0168', 'pos/income', '0168-161806220844.jpg', 'photo_2021-04-10_20-38-48.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-10 13:43:28'),
('0168-0045', '0168-0041', '0168', 'pos/income', '0168-161829857430.jpg', 'photo_2021-04-13_14-11-32.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:55'),
('0168-0046', '0168-0041', '0168', 'pos/income', '0168-161829857599.jpg', 'photo_2021-04-13_14-11-42.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:55'),
('0168-0047', '0168-0041', '0168', 'pos/income', '0168-161829857510.jpg', 'photo_2021-04-13_14-11-39.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-13 07:22:55'),
('0168-0048', '0168-0042', '0168', 'pos/income', '0168-161846870039.png', 'E1CFF721-30A1-4CEA-91F5-E1B7F9D0B39A.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-04-15 06:38:21'),
('0168-0049', '0168-0042', '0168', 'pos/income', '0168-161846870181.jpg', 'D773FC38-6178-47D8-8059-5A551C1904E6.jpeg', '.jpeg', 'income', 'TECHNOZOON@gmail.com', '2021-04-15 06:38:21'),
('0168-0054', '0168-0046', '0168', 'pos/expense/', '0168-161951450814.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:29'),
('0168-0055', '0168-0046', '0168', 'pos/expense/', '0168-161951450941.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:29'),
('0168-0056', '0168-0047', '0168', 'pos/expense/', '0168-161951451856.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:38'),
('0168-0057', '0168-0047', '0168', 'pos/expense/', '0168-161951451859.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:38'),
('0168-0058', '0168-0048', '0168', 'pos/expense/', '0168-161951452338.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:43'),
('0168-0059', '0168-0048', '0168', 'pos/expense/', '0168-161951452350.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:43'),
('0168-0060', '0168-0049', '0168', 'pos/expense/', '0168-161951452935.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:49'),
('0168-0061', '0168-0049', '0168', 'pos/expense/', '0168-161951452970.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:08:49'),
('0168-0062', '0168-0050', '0168', 'pos/expense/', '0168-161951454028.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:00'),
('0168-0063', '0168-0050', '0168', 'pos/expense/', '0168-161951454049.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:00'),
('0168-0064', '0168-0051', '0168', 'pos/expense/', '0168-161951455233.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:12'),
('0168-0065', '0168-0051', '0168', 'pos/expense/', '0168-161951455285.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:12'),
('0168-0066', '0168-0052', '0168', 'pos/expense/', '0168-161951456089.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:20'),
('0168-0067', '0168-0052', '0168', 'pos/expense/', '0168-161951456061.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:21'),
('0168-0068', '0168-0053', '0168', 'pos/expense/', '0168-161951456833.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:28'),
('0168-0069', '0168-0053', '0168', 'pos/expense/', '0168-161951456816.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:28'),
('0168-0070', '0168-0054', '0168', 'pos/expense/', '0168-161951457473.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:34'),
('0168-0071', '0168-0054', '0168', 'pos/expense/', '0168-161951457488.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:34'),
('0168-0074', '0168-0056', '0168', 'pos/expense/', '0168-16195145949.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:54'),
('0168-0075', '0168-0056', '0168', 'pos/expense/', '0168-161951459466.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:09:54'),
('0168-0076', '0168-0057', '0168', 'pos/expense/', '0168-161951460062.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:10:00'),
('0168-0077', '0168-0057', '0168', 'pos/expense/', '0168-161951460043.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:10:00'),
('0168-0078', '0168-0058', '0168', 'pos/expense/', '0168-161951460833.png', 'E8BD8243-51D8-4FA5-A2CD-E8A93D687E5A.png', '.png', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:10:08'),
('0168-0079', '0168-0058', '0168', 'pos/expense/', '0168-161951460893.jpg', 'C633D239-6F29-46B2-B1DB-2AD7FA62FBA7.jpeg', '.jpeg', 'exspense', 'TECHNOZOON@gmail.com', '2021-04-27 09:10:08'),
('0168-0080', '0168-0059', '0168', 'pos/income', '0168-161953300827.jpg', 'photo_2021-04-27_21-14-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-27 14:16:48'),
('0168-0081', '0168-0060', '0168', 'pos/income', '0168-161958021312.jpg', 'Razer mouse.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-04-28 03:23:33'),
('0168-0085', '0168-0063', '0168', 'pos/income', '0168-162002625966.png', '0019.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-03 07:17:39'),
('0168-0086', '0168-0063', '0168', 'pos/income', '0168-162002625917.png', '0020.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-03 07:17:39'),
('0168-0087', '0168-0064', '0168', 'pos/income', '0168-162020800788.jpg', '780854C8-D753-4F8F-83C4-CDC96E011845.jpeg', '.jpeg', 'income', 'TECHNOZOON@gmail.com', '2021-05-05 09:46:47'),
('0168-0088', '0168-0065', '0168', 'pos/income', '0168-162022495824.jpg', 'IMG_20210505_212835_015.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-05 14:29:18'),
('0168-0089', '0168-0066', '0168', 'pos/income', '0168-162034386435.png', 'A73D3C56-039E-4A55-BB3C-AA8B15FA4D0F.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-06 23:31:04'),
('0168-0090', '0168-0067', '0168', 'pos/income', '0168-162034395332.png', 'B94B85FC-C893-4733-9D70-5F2699104CF6.png', '.png', 'income', 'TECHNOZOON@gmail.com', '2021-05-06 23:32:33'),
('0168-0093', '0168-0069', '0168', 'pos/income', '0168-162044915313.jpg', 'B757FBD8-4434-491F-B0C5-C5FD7F6DC90B.jpeg', '.jpeg', 'income', 'TECHNOZOON@gmail.com', '2021-05-08 04:45:53'),
('0168-0094', '0168-0073', '0168', 'pos/income', '0168-162079666485.jpg', 'photo_2021-05-12_12-17-31.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-12 05:17:45'),
('0168-0095', '0168-0074', '0168', 'pos/income', '0168-162096565658.jpg', 'photo_2021-05-13_13-07-34.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:16'),
('0168-0096', '0168-0074', '0168', 'pos/income', '0168-162096565653.jpg', 'photo_2021-05-13_13-07-35.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:16'),
('0168-0097', '0168-0075', '0168', 'pos/income', '0168-162096569292.jpg', 'photo_2021-05-14_11-12-47.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-14 04:14:52'),
('0168-0100', '0168-0077', '0168', 'pos/income', '0168-16212427286.jpg', 'photo_2021-05-17_16-11-17.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-17 09:12:09'),
('0168-0105', '0168-0080', '0168', 'pos/income', '0168-162160071865.jpg', 'photo_2021-05-21_19-36-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-21 12:38:38'),
('0168-0106', '0168-0082', '0168', 'pos/income', '0168-162165765063.jpg', 'photo_2021-05-22_11-27-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-22 04:27:30'),
('0168-0111', '0168-0094', '0168', 'pos/income', '0168-162242250585.jpg', 'photo_2021-05-31_07-54-51.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-05-31 00:55:05'),
('0168-0113', '0168-0104', '0168', 'pos/income', '0168-162298517494.jpg', 'photo_2021-06-06_17-55-15.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-06 13:12:54'),
('0168-0114', '0168-0107', '0168', 'pos/income', '0168-162339031952.jpg', 'photo_2021-06-11_12-45-11.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-11 05:45:19'),
('0168-0115', '0168-0112', '0168', 'pos/income', '0168-1623568420100.jpg', 'photo_2021-06-13_11-40-39.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-13 07:13:40'),
('0168-0116', '0168-0113', '0168', 'pos/income', '0168-162409800116.jpg', 'photo_2021-06-19_17-19-15.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-19 10:20:01'),
('0168-0117', '0168-0114', '0168', 'pos/income', '0168-162426125766.jpg', 'photo_2021-06-21_14-40-10.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-21 07:40:57'),
('0168-0118', '0168-0115', '0168', 'pos/income', '0168-162469481328.jpg', 'photo_2021-06-26_14-44-00.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-26 08:06:53'),
('0168-0119', '0168-0117', '0168', 'pos/income', '0168-162504475035.jpg', 'photo_2021-06-30_14-27-36.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-06-30 09:19:10'),
('0168-0121', '0168-0122', '0168', 'pos/income', '0168-162523601825.jpg', 'photo_2021-07-01_14-02-01.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-02 14:26:58'),
('0168-0122', '0168-0124', '0168', 'pos/income', '0168-162571695571.jpg', 'photo_2021-07-08_11-01-04.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-08 04:02:35'),
('0168-0123', '0168-0125', '0168', 'pos/income', '0168-162606132536.jpg', 'photo_2021-07-12_10-36-00.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-12 03:42:05'),
('0168-0124', '0168-0126', '0168', 'pos/income', '0168-162606137886.jpg', 'photo_2021-07-12_10-35-49.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-12 03:42:58'),
('0168-0125', '0168-0127', '0168', 'pos/income', '0168-162606142691.jpg', 'photo_2021-07-12_09-55-31.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-12 03:43:46'),
('0168-0128', '0168-0130', '0168', 'pos/income', '0168-162644108795.jpg', 'photo_2021-07-16_20-08-11.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-16 13:11:27'),
('0168-0129', '0168-0131', '0168', 'pos/income', '0168-162644112268.jpg', 'photo_2021-07-16_20-08-11.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-16 13:12:02'),
('0168-0134', '0168-0135', '0168', 'pos/income', '0168-162685772541.jpg', 'photo_2021-07-21_15-54-46.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-21 08:55:25'),
('0168-0135', '0168-0135', '0168', 'pos/income', '0168-162685772523.jpg', 'photo_2021-07-21_14-30-16.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-21 08:55:25'),
('0168-0136', '0168-0136', '0168', 'pos/income', '0168-162753779416.jpg', 'photo_2021-07-29_12-49-39.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-29 05:49:54'),
('0168-0137', '0168-0137', '0168', 'pos/income', '0168-162764858717.jpg', 'photo_2021-07-30_13-51-00.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-30 12:36:27'),
('0168-0138', '0168-0138', '0168', 'pos/income', '0168-162769811928.jpg', 'photo_2021-07-31_08-58-46.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-07-31 02:22:00'),
('0168-0140', '0168-0143', '0168', 'pos/income', '0168-162814313594.jpg', 'photo_2021-08-05_12-55-53.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-08-05 05:58:55'),
('0168-0141', '0168-0144', '0168', 'pos/income', '0168-162815175415.jpg', 'photo_2021-08-05_15-17-58.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-08-05 08:22:34'),
('0168-0145', '0168-0151', '0168', 'pos/income', '0168-162926079151.jpg', 'photo_2021-08-18_11-25-21.jpg', '.jpg', 'income', 'TECHNOZOON@gmail.com', '2021-08-18 04:26:31'),
('0168-0155', '0168-0177', '0168', 'pos/income', '0168-163091021939.jpg', 'photo_2021-09-06_13-26-53.jpg', '.jpg', 'income', 'technozoon@gmail.com', '2021-09-06 06:37:00'),
('0168-0156', '0168-0182', '0168', 'pos/income', '0168-163091060677.jpg', 'photo_2021-09-06_13-26-53.jpg', '.jpg', 'income', 'technozoon@gmail.com', '2021-09-06 06:43:26');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_expense`
--

CREATE TABLE `pos_tbl_una_expense` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `lin_id` varchar(20) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `referent` varchar(250) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `close_num` varchar(50) DEFAULT NULL,
  `close_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_expense`
--

INSERT INTO `pos_tbl_una_expense` (`tran_code`, `branchcode`, `lin_id`, `currency`, `amount`, `referent`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `close_num`, `close_date`) VALUES
('0168-0176', '0168', '0168-0025', '01', '13.51', 'ZTO Shipping Car toy', '', 'technozoon@gmail.com', '2021-09-03 23:37:21', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_income`
--

CREATE TABLE `pos_tbl_una_income` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `lin_id` varchar(20) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `referent` varchar(250) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `close_num` varchar(20) DEFAULT NULL,
  `close_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_income`
--

INSERT INTO `pos_tbl_una_income` (`tran_code`, `branchcode`, `lin_id`, `currency`, `amount`, `referent`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `close_num`, `close_date`) VALUES
('0168-0177', '0168', '0168-0023', '01', '30.00', 'Xiaomi Mi Wifi Booster(0136)', '', 'technozoon@gmail.com', '2021-09-06 06:36:59', NULL, NULL, NULL, NULL),
('0168-0178', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0137)', '', 'technozoon@gmail.com', '2021-09-06 06:38:32', NULL, NULL, NULL, NULL),
('0168-0179', '0168', '0168-0023', '01', '17.00', 'KS06 HIFI Gaming(0138)', '', 'technozoon@gmail.com', '2021-09-06 06:39:06', NULL, NULL, NULL, NULL),
('0168-0180', '0168', '0168-0023', '01', '15.00', 'Xiaomi Mi Wifi Booster(0139)', '', 'technozoon@gmail.com', '2021-09-06 06:41:18', NULL, NULL, NULL, NULL),
('0168-0181', '0168', '0168-0023', '01', '49.00', 'Projector YG320(0140)', '', 'technozoon@gmail.com', '2021-09-06 06:42:04', NULL, NULL, NULL, NULL),
('0168-0182', '0168', '0168-0023', '01', '30.00', 'Xiaomi Mi Wifi Booster(0141)', '', 'technozoon@gmail.com', '2021-09-06 06:43:26', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_invoices`
--

CREATE TABLE `pos_tbl_una_invoices` (
  `inv_num` varchar(20) NOT NULL,
  `cus_id` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `inv_date` datetime DEFAULT NULL,
  `inv_reason` varchar(250) DEFAULT NULL,
  `inv_exchange` decimal(13,2) DEFAULT NULL,
  `inv_referent` varchar(50) DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_invoices`
--

INSERT INTO `pos_tbl_una_invoices` (`inv_num`, `cus_id`, `branchcode`, `inv_date`, `inv_reason`, `inv_exchange`, `inv_referent`, `sys_token`, `inputter`, `inputdate`, `authorizer`, `auth_date`) VALUES
('0014', '0008', '0027', '2021-03-24 14:00:35', NULL, '4100.00', NULL, '0027-605ae39370f56', 'bongmap@gmail.com', '2021-03-24 14:00:35', NULL, NULL),
('0101', '0082', '0168', '2021-07-17 06:12:48', NULL, '4100.00', NULL, '0168-60f274e042af5', 'Sale@gmail.com', '2021-07-17 06:12:48', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_invoice_return`
--

CREATE TABLE `pos_tbl_una_invoice_return` (
  `inv_num` varchar(20) NOT NULL,
  `cus_id` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `inv_date` datetime DEFAULT NULL,
  `inv_reason` varchar(250) DEFAULT NULL,
  `inv_exchange` decimal(13,2) DEFAULT NULL,
  `inv_referent` varchar(50) DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_invoice_return`
--

INSERT INTO `pos_tbl_una_invoice_return` (`inv_num`, `cus_id`, `branchcode`, `inv_date`, `inv_reason`, `inv_exchange`, `inv_referent`, `sys_token`, `inputter`, `inputdate`, `authorizer`, `auth_date`) VALUES
('0007', '0002', '0004', '2021-03-29 15:27:18', 'Customer reject or have problem', '4100.00', '0006', '0004-6061f1d62b663', 'technodemo@gmail.com', '2021-03-29 15:27:18', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_purchase_details`
--

CREATE TABLE `pos_tbl_una_purchase_details` (
  `sysdonum` varchar(10) NOT NULL,
  `pur_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `barcode` varchar(10) DEFAULT NULL,
  `stockcode` varchar(10) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_qty` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pur_amount` decimal(13,2) DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `pur_remark` varchar(250) DEFAULT NULL,
  `pur_exchange` decimal(13,2) DEFAULT NULL,
  `pro_expired` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_purchase_order`
--

CREATE TABLE `pos_tbl_una_purchase_order` (
  `pur_id` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `sup_id` varchar(45) DEFAULT NULL,
  `pur_invoice` varchar(45) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_stockouts`
--

CREATE TABLE `pos_tbl_una_stockouts` (
  `sto_num` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `inv_num` varchar(50) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `pro_barcode` varchar(10) DEFAULT NULL,
  `stock_code` varchar(10) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_qty` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pro_amount` decimal(13,2) DEFAULT NULL,
  `pro_qty_amount` decimal(13,2) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_stockouts`
--

INSERT INTO `pos_tbl_una_stockouts` (`sto_num`, `branchcode`, `inv_num`, `pro_code`, `pro_barcode`, `stock_code`, `pro_cost`, `pro_qty`, `pro_up`, `pro_discount`, `pro_amount`, `pro_qty_amount`, `trandate`) VALUES
('0013', '0027', '0014', '0027-0006', '00001', '0027-0019', '350.00', '1.00', '450.00', '0.00', '450.00', NULL, NULL),
('0014', '0027', '0014', '0027-0017', '00666', '0027-0021', '300.00', '2.00', '4900.00', '5.00', '9310.00', NULL, NULL),
('0107', '0168', '0101', '0168-0032', '0035', '0168-0004', '7.00', '1.00', '12.00', '0.00', '12.00', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_stockout_return`
--

CREATE TABLE `pos_tbl_una_stockout_return` (
  `sto_num` varchar(10) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `inv_num` varchar(50) NOT NULL,
  `pro_code` varchar(10) DEFAULT NULL,
  `pro_barcode` varchar(10) DEFAULT NULL,
  `stock_code` varchar(10) DEFAULT NULL,
  `pro_cost` decimal(13,2) DEFAULT NULL,
  `pro_qty` decimal(13,2) DEFAULT NULL,
  `pro_up` decimal(13,2) DEFAULT NULL,
  `pro_discount` decimal(13,2) DEFAULT NULL,
  `pro_amount` decimal(13,2) DEFAULT NULL,
  `pro_qty_amount` decimal(13,2) DEFAULT NULL,
  `trandate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_stockout_return`
--

INSERT INTO `pos_tbl_una_stockout_return` (`sto_num`, `branchcode`, `inv_num`, `pro_code`, `pro_barcode`, `stock_code`, `pro_cost`, `pro_qty`, `pro_up`, `pro_discount`, `pro_amount`, `pro_qty_amount`, `trandate`) VALUES
('0003', '0004', '0007', '0004-0002', 'A0002', '0004-0005', '155.00', '1.00', '165.00', '0.00', '165.00', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_stocktransfer`
--

CREATE TABLE `pos_tbl_una_stocktransfer` (
  `tran_code` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `f_stock` varchar(20) DEFAULT NULL,
  `t_stock` varchar(20) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `auth_date` datetime DEFAULT NULL,
  `sys_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_stocktransfer`
--

INSERT INTO `pos_tbl_una_stocktransfer` (`tran_code`, `branchcode`, `f_stock`, `t_stock`, `remark`, `inputter`, `inputdate`, `authorizer`, `auth_date`, `sys_token`) VALUES
('0001', '0168', '0168-0004', '0168-0003', 'Mr.Map get for testing at home', 'TECHNOZOON@gmail.com', '2021-08-12 11:05:22', NULL, NULL, '0168-611500723551e');

-- --------------------------------------------------------

--
-- Table structure for table `pos_tbl_una_stocktransfer_detail`
--

CREATE TABLE `pos_tbl_una_stocktransfer_detail` (
  `sysdocnum` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `tran_code` varchar(20) DEFAULT NULL,
  `pro_code` varchar(20) DEFAULT NULL,
  `barcode` varchar(20) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pos_tbl_una_stocktransfer_detail`
--

INSERT INTO `pos_tbl_una_stocktransfer_detail` (`sysdocnum`, `branchcode`, `tran_code`, `pro_code`, `barcode`, `qty`) VALUES
('0002', '0168', '0001', '0168-0029', '0033', '1.00'),
('0003', '0168', '0001', '0168-0030', 'B0021', '1.00'),
('0004', '0168', '0001', '0168-0043', 'B0046', '1.00'),
('0005', '0168', '0001', '0168-0014', 'B0007', '1.00');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_land_tillers`
--

CREATE TABLE `tbl_land_tillers` (
  `tiller_num` varchar(20) NOT NULL,
  `branchcode` varchar(10) NOT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` varchar(50) DEFAULT NULL,
  `authorizer` varchar(50) DEFAULT NULL,
  `authorizedate` datetime DEFAULT NULL,
  `postreferent` varchar(45) DEFAULT NULL,
  `postdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_main_left_menu`
--

CREATE TABLE `tbl_main_left_menu` (
  `menu_id` varchar(45) NOT NULL,
  `menu_name` varchar(45) DEFAULT '''NULL''',
  `menu_effective_date` datetime NOT NULL,
  `menu_inactive` varchar(10) DEFAULT '''NULL''',
  `menu_inputer` varchar(45) DEFAULT '''NULL''',
  `menu_glyphicon1` varchar(45) DEFAULT '''NULL''',
  `menu_glyphicon2` varchar(255) DEFAULT '''NULL''',
  `menu_glyphicon3` varchar(255) DEFAULT '''NULL''',
  `menu_class1` varchar(255) DEFAULT '''NULL''',
  `menu_class2` varchar(255) DEFAULT '''NULL''',
  `menu_class3` varchar(255) DEFAULT '''NULL''',
  `menu_order` int(11) DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=156 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_main_left_menu`
--

INSERT INTO `tbl_main_left_menu` (`menu_id`, `menu_name`, `menu_effective_date`, `menu_inactive`, `menu_inputer`, `menu_glyphicon1`, `menu_glyphicon2`, `menu_glyphicon3`, `menu_class1`, `menu_class2`, `menu_class3`, `menu_order`) VALUES
('0001', 'Super User', '2019-05-31 00:00:00', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 1),
('0002', 'POS System', '2019-05-31 00:00:00', '0', 'IT.SYSTEM', 'fa fa-eye', '2', '3', 'nav-icon fas fa-tree', '5', '6', 2),
('0003', 'Setting', '2019-05-01 00:00:00', '0', 'abc', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-edit', NULL, NULL, 99),
('0004', 'LAND', '2019-01-01 00:00:00', '0', 'bongmap@gmail.com', 'fa fa-eye', 'fa fa-angle-left pull-right', NULL, 'nav-icon fas fa-table', 'pull-right-container', 'right fas fa-angle-left', 3),
('0005', 'Land Accounting', '2020-11-14 20:32:46', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 4),
('0006', 'COFFEE', '2020-12-13 09:26:01', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 5),
('0007', 'Report Land', '2021-02-14 20:54:50', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 90),
('0009', 'Report POS', '2021-02-14 21:03:07', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 91),
('0010', 'Report Hospital', '2021-02-14 21:06:36', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 92),
('0012', 'POS Accounting', '2021-03-29 13:40:23', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 6),
('0013', 'HMS Accounting', '2021-03-29 13:41:08', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 7),
('0014', 'POST', '2021-03-29 15:53:44', '0', 'IT.SYSTEM', 'fa fa-eye', NULL, NULL, 'nav-icon fas fa-chart-pie', NULL, NULL, 10);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_menu_permission`
--

CREATE TABLE `tbl_menu_permission` (
  `per_id` varchar(10) NOT NULL,
  `menu_id` varchar(10) NOT NULL,
  `systemid` varchar(15) DEFAULT NULL,
  `views` tinyint(4) DEFAULT NULL,
  `booking` tinyint(4) DEFAULT NULL,
  `edit` tinyint(4) DEFAULT NULL,
  `deletes` tinyint(4) DEFAULT NULL,
  `menu_order` int(11) DEFAULT NULL,
  `keytoken` varchar(100) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_menu_permission`
--

INSERT INTO `tbl_menu_permission` (`per_id`, `menu_id`, `systemid`, `views`, `booking`, `edit`, `deletes`, `menu_order`, `keytoken`, `inputter`, `inputdate`) VALUES
('0293', '0001', '30', 0, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0294', 'SUB0014', '30', 0, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0295', 'SUB0021', '30', 0, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0296', 'SUB0022', '30', 0, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0297', 'SUB0025', '30', 0, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0298', '0002', '30', 1, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0299', 'SUB0001', '30', 1, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0300', 'SUB0002', '30', 1, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0301', 'SUB0008', '30', 1, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0302', 'SUB0009', '30', 1, 0, 0, 0, NULL, '610aaf4ee090a', 'bongmap@gmail.com', '2021-08-04 15:16:30'),
('0343', 'SUB0039', '30', 0, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0344', '0007', '30', 0, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0345', 'SUB0016', '30', 0, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0346', 'SUB0018', '30', 0, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0347', 'SUB0019', '30', 0, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0348', '0009', '30', 1, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0349', 'SUB0026', '30', 1, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0350', 'SUB0031', '30', 1, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0351', 'SUB0032', '30', 1, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0352', 'SUB0033', '30', 1, 0, 0, 0, NULL, '610aaf819be91', 'bongmap@gmail.com', '2021-08-04 15:17:21'),
('0353', 'SUB0020', '30', 1, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0354', 'SUB0023', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0355', 'SUB0029', '30', 1, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0356', 'SUB0040', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0357', '0004', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0358', '0005', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0359', 'SUB0005', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0360', 'SUB0006', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0361', '0006', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0362', 'SUB0004', '30', 0, 0, 0, 0, NULL, '610ab23bad17d', 'bongmap@gmail.com', '2021-08-04 15:28:59'),
('0373', 'SUB0034', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0374', 'SUB0035', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0375', 'SUB0036', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0376', 'SUB0037', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0377', 'SUB0038', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0378', '0010', '30', 0, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0379', '0012', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0380', 'SUB0027', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0381', 'SUB0028', '30', 1, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0382', '0013', '30', 0, 0, 0, 0, NULL, '610b7da85391a', 'bongmap@gmail.com', '2021-08-05 05:56:56'),
('0383', 'SUB0010', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0384', 'SUB0011', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0385', 'SUB0012', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0386', 'SUB0013', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0387', 'SUB0024', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0388', '0003', '20', 1, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0389', 'SUB0003', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0390', 'SUB0007', '20', 0, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0391', 'SUB0015', '20', 1, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0392', 'SUB0017', '20', 1, 0, 0, 0, NULL, '610e52bc3b500', 'bongmap@gmail.com', '2021-08-07 09:30:36'),
('0433', 'SUB0006', '20', 1, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0434', '0006', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0435', 'SUB0004', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0436', 'SUB0039', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0437', '0007', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0438', '0009', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0439', 'SUB0026', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0440', 'SUB0031', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0441', 'SUB0032', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0442', 'SUB0033', '20', 0, 0, 0, 0, NULL, '610e52d0ef0d6', 'bongmap@gmail.com', '2021-08-07 09:30:56'),
('0443', 'SUB0020', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0444', 'SUB0023', '20', 0, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0445', 'SUB0029', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0446', 'SUB0040', '20', 0, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0447', '0004', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0448', 'SUB0016', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0449', 'SUB0018', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0450', 'SUB0019', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0451', '0005', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0452', 'SUB0005', '20', 1, 0, 0, 0, NULL, '61153ffb7b40d', 'bongmap@gmail.com', '2021-08-12 15:36:27'),
('0453', '0014', '30', 1, 0, 0, 0, NULL, '611693213af8f', 'bongmap@gmail.com', '2021-08-13 15:43:29'),
('0454', 'SUB0041', '30', 1, 0, 0, 0, NULL, '611693213af8f', 'bongmap@gmail.com', '2021-08-13 15:43:29'),
('0485', 'SUB0010', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0486', 'SUB0011', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0487', 'SUB0012', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0488', 'SUB0013', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0489', 'SUB0024', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0490', '0003', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0491', 'SUB0003', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0492', 'SUB0007', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0493', 'SUB0015', '30', 1, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33'),
('0494', 'SUB0017', '30', 0, 0, 0, 0, NULL, '6125e9a114122', 'bongmap@gmail.com', '2021-08-25 06:56:33');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_menu_permission_branch`
--

CREATE TABLE `tbl_menu_permission_branch` (
  `per_id` varchar(20) NOT NULL,
  `menu_id` varchar(20) NOT NULL,
  `profile_id` varchar(20) NOT NULL,
  `branchcode` varchar(20) NOT NULL,
  `views` tinyint(4) DEFAULT NULL,
  `booking` tinyint(4) DEFAULT NULL,
  `edit` tinyint(4) DEFAULT NULL,
  `deletes` tinyint(4) DEFAULT NULL,
  `keytoken` varchar(45) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_menu_permission_branch`
--

INSERT INTO `tbl_menu_permission_branch` (`per_id`, `menu_id`, `profile_id`, `branchcode`, `views`, `booking`, `edit`, `deletes`, `keytoken`, `inputter`, `inputdate`) VALUES
('0001-auto3702', '0001', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3703', '11', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3704', '3', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3705', '4', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3706', '8', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3707', '0002', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3708', '0030', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3709', '1', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3719', '0021', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3759', '0020', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3760', '6', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3761', '0006', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3762', '0051', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3763', '0056', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3764', '14', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3765', '18', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3766', '23', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3767', '5', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3768', '0007', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3780', '17', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3781', '19', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3782', '20', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3783', '0017', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3784', '0053', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3785', '0054', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3786', '0018', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3787', '0052', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3788', '0055', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0001-auto3789', '0019', '0001', '0001', 1, 1, 1, 1, '0001-20', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0132', 'SUB0010', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0133', 'SUB0011', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0134', 'SUB0012', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0135', 'SUB0013', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0136', 'SUB0024', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0137', '0003', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0138', 'SUB0003', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0139', 'SUB0007', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0140', 'SUB0015', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0141', 'SUB0017', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0142', 'SUB0020', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0142', 'SUB0020', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0143', 'SUB0023', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0143', 'SUB0023', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0144', '0004', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0144', '0004', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0145', '0005', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0145', '0005', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0146', 'SUB0005', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0146', 'SUB0005', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0147', 'SUB0006', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0147', 'SUB0006', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0148', '0006', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0148', '0006', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0149', 'SUB0004', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0149', 'SUB0004', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0150', '0007', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0150', '0007', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0151', 'SUB0016', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0151', 'SUB0016', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0152', 'SUB0018', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0153', 'SUB0019', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0154', '0009', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0155', 'SUB0026', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0156', '0010', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0157', '0011', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0158', '0012', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0159', 'SUB0027', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0160', '0013', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0161', '0014', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0162', '0001', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0162', '0001', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0163', 'SUB0014', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0163', 'SUB0014', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0164', 'SUB0021', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0164', 'SUB0021', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0165', 'SUB0022', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0165', 'SUB0022', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0166', 'SUB0025', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0166', 'SUB0025', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0167', '0002', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0167', '0002', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0168', 'SUB0001', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0169', 'SUB0002', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0169', 'SUB0002', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0170', 'SUB0008', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0170', 'SUB0008', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0171', 'SUB0009', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto0171', 'SUB0009', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0182', 'SUB0018', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0183', 'SUB0019', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0192', 'SUB0010', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0193', 'SUB0011', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0194', 'SUB0012', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0196', 'SUB0024', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0197', '0003', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0198', 'SUB0003', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0199', 'SUB0007', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0200', 'SUB0015', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0201', 'SUB0017', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0202', 'SUB0013', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0211', '0015', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0212', 'SUB0001', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0224', 'SUB0026', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0227', '0012', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0228', 'SUB0027', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0229', 'SUB0028', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0230', 'SUB0029', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0231', '0013', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0232', '0014', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0251', 'SUB0037', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0262', '0011', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0282', '0010', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0283', '0009', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0284', 'SUB0030', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0285', 'SUB0031', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0286', 'SUB0032', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0287', 'SUB0033', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0288', 'SUB0034', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0289', 'SUB0035', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0290', 'SUB0036', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0291', 'SUB0038', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto0292', 'SUB0039', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3248', '21', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3248', '21', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3771', '11', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3771', '11', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3772', '3', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3772', '3', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3773', '4', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3773', '4', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3774', '8', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3774', '8', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3776', '0030', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3776', '0030', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3777', '0057', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3777', '0057', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3778', '0058', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3778', '0058', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3779', '0059', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3779', '0059', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3810', '0062', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3810', '0062', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3811', '0063', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3811', '0063', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3812', '1', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3812', '1', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3813', '6', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3813', '6', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3815', '0051', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3815', '0051', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3816', '0056', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3816', '0056', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3817', '14', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3817', '14', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3818', '18', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3818', '18', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3819', '23', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3819', '23', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3856', '0019', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3856', '0019', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3857', '0020', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3857', '0020', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3858', '0021', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3858', '0021', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3859', '5', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3859', '5', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3861', '17', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3861', '17', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3862', '19', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3862', '19', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3863', '20', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3863', '20', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3864', '0017', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3864', '0017', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3865', '0053', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3865', '0053', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3866', '0054', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3866', '0054', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3867', '0018', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3867', '0018', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0004-auto3868', '0052', '0004-0001', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-03-29 16:17:42'),
('0004-auto3868', '0052', '0004-0002', '0004', 1, 1, 1, 1, '0004-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-0308', '0002', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0309', 'SUB0002', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0310', 'SUB0008', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0311', 'SUB0009', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0312', 'SUB0010', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0313', 'SUB0011', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0314', 'SUB0012', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0315', 'SUB0024', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0316', '0003', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0317', 'SUB0003', '0168-0002', '0168', 0, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0318', 'SUB0007', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0319', 'SUB0015', '0168-0002', '0168', 0, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0320', 'SUB0020', '0168-0002', '0168', 0, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0321', 'SUB0023', '0168-0002', '0168', 0, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0322', '0009', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0323', 'SUB0030', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0324', 'SUB0031', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0325', 'SUB0032', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0326', 'SUB0033', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0327', 'SUB0034', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0328', 'SUB0035', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0329', 'SUB0036', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0330', 'SUB0038', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0331', 'SUB0039', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0332', '0012', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0333', 'SUB0027', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0334', 'SUB0028', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0335', 'SUB0029', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0336', '0015', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0337', 'SUB0001', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0338', 'SUB0013', '0168-0002', '0168', 1, 0, 0, 0, '60abc12a6209e', 'TECHNOZOON@gmail.com', '2021-05-24 15:07:22'),
('0168-0370', '0002', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0371', 'SUB0002', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0372', 'SUB0008', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0373', 'SUB0009', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0374', 'SUB0010', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0375', 'SUB0011', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0376', 'SUB0012', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0377', 'SUB0024', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0378', '0003', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0379', 'SUB0003', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0380', 'SUB0007', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0381', 'SUB0015', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0382', 'SUB0020', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0383', 'SUB0023', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0384', '0009', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0385', 'SUB0030', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0386', 'SUB0031', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0387', 'SUB0032', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0388', 'SUB0033', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0389', 'SUB0034', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0390', 'SUB0035', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0391', 'SUB0036', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0392', 'SUB0038', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0393', 'SUB0039', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0394', '0012', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0395', 'SUB0027', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0396', 'SUB0028', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0397', 'SUB0029', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0398', '0015', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0399', 'SUB0001', '0168-0003', '0168', 0, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-0400', 'SUB0013', '0168-0003', '0168', 1, 0, 0, 0, '60f2797b88377', 'TECHNOZOON@gmail.com', '2021-07-17 06:32:27'),
('0168-auto0142', 'SUB0020', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0143', 'SUB0023', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0144', '0004', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0145', '0005', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0146', 'SUB0005', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0147', 'SUB0006', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0148', '0006', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0149', 'SUB0004', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0150', '0007', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0151', 'SUB0016', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0162', '0001', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0163', 'SUB0014', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0164', 'SUB0021', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0165', 'SUB0022', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0166', 'SUB0025', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0167', '0002', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0169', 'SUB0002', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0170', 'SUB0008', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0171', 'SUB0009', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0182', 'SUB0018', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0183', 'SUB0019', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0192', 'SUB0010', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0193', 'SUB0011', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0194', 'SUB0012', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0196', 'SUB0024', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0197', '0003', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0198', 'SUB0003', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0199', 'SUB0007', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0200', 'SUB0015', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0201', 'SUB0017', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0202', 'SUB0013', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0211', '0015', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0212', 'SUB0001', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0224', 'SUB0026', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0227', '0012', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0228', 'SUB0027', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0229', 'SUB0028', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0230', 'SUB0029', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0231', '0013', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0232', '0014', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0251', 'SUB0037', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0262', '0011', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0282', '0010', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0283', '0009', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0284', 'SUB0030', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0285', 'SUB0031', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0286', 'SUB0032', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0287', 'SUB0033', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0288', 'SUB0034', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0289', 'SUB0035', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0290', 'SUB0036', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0291', 'SUB0038', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto0292', 'SUB0039', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3248', '21', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3771', '11', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3772', '3', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3773', '4', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3774', '8', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3776', '0030', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3777', '0057', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3778', '0058', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3779', '0059', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3810', '0062', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3811', '0063', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3812', '1', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3813', '6', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3815', '0051', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3816', '0056', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3817', '14', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3818', '18', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3819', '23', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3856', '0019', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3857', '0020', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3858', '0021', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3859', '5', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3861', '17', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3862', '19', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3863', '20', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3864', '0017', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3865', '0053', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3866', '0054', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3867', '0018', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48'),
('0168-auto3868', '0052', '0168-0001', '0168', 1, 1, 1, 1, '0168-30', 'IT.SYSTEM', '2021-05-24 14:46:48');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_menu_permission_profile`
--

CREATE TABLE `tbl_menu_permission_profile` (
  `per_id` varchar(20) NOT NULL,
  `menu_id` varchar(20) NOT NULL,
  `profile_id` varchar(20) NOT NULL,
  `views` tinyint(4) DEFAULT NULL,
  `booking` tinyint(4) DEFAULT NULL,
  `edit` tinyint(4) DEFAULT NULL,
  `deletes` tinyint(4) DEFAULT NULL,
  `keytoken` varchar(45) DEFAULT NULL,
  `inputter` varchar(200) DEFAULT NULL,
  `inputdate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sub_left_menu`
--

CREATE TABLE `tbl_sub_left_menu` (
  `subm_id` varchar(50) NOT NULL,
  `menu_id` varchar(45) DEFAULT '''NULL''',
  `subm_name` varchar(45) DEFAULT '''NULL''',
  `subm_controller` varchar(50) NOT NULL,
  `subm_function` varchar(45) DEFAULT '''NULL''',
  `subm_inactive` varchar(45) DEFAULT '''NULL''',
  `subm_inputer` varchar(45) DEFAULT '''NULL''',
  `subm_glyphicon` varchar(45) DEFAULT '''NULL''',
  `subm_effective_date` datetime DEFAULT NULL,
  `subm_order` int(11) DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=64 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_sub_left_menu`
--

INSERT INTO `tbl_sub_left_menu` (`subm_id`, `menu_id`, `subm_name`, `subm_controller`, `subm_function`, `subm_inactive`, `subm_inputer`, `subm_glyphicon`, `subm_effective_date`, `subm_order`) VALUES
('SUB0013', '0002', 'POS Sale', 'pos', 'pos_pos', '0', NULL, 'fa fa-user', '2020-08-15 21:30:22', 4),
('SUB0022', '0001', 'Admin Menu', 'admin1111', 'admin_menu', '0', NULL, 'fa fa-hand-o-right', '2020-08-15 21:30:22', 0),
('SUB0023', '0003', 'Setup Profile', 'Setting', 'setup_profile', '0', NULL, 'fa fa-plus-circle', '2020-08-15 21:30:22', 2),
('SUB0024', '0002', 'Reg Suppllier', 'pos', 'register_supply', '0', NULL, 'fa fa-shopping-cart', '2020-08-15 21:30:22', 3),
('SUB0021', '0001', 'Sub menu', 'admin', 'sub_menu', '0', NULL, 'fa fa-user-circle-o', '2020-08-15 21:30:22', 3),
('SUB0003', '0003', 'User permission', 'Setting', 'setuser_permission', '0', 'IT.SYSTEM', '\'NULL\'', '2020-11-14 20:34:19', 100),
('SUB0025', '0001', 'Set Permission', 'Admin', 'menu_permission', '0', NULL, 'fa fa-folder-open', '2020-08-15 21:30:22', 0),
('SUB0014', '0001', 'Create System', 'admin', 'create_system', '0', NULL, 'fa fa-hand-o-right', '2020-08-15 21:30:22', 5),
('SUB0015', '0003', 'Setup User', 'Setting', 'setupuser', '0', NULL, 'fa fa-folder-open', '2020-08-15 21:30:22', 6),
('SUB0016', '0004', 'Customer info', 'admin', 'customer_land', '0', 'bongmap@gmail.com', 'fa fa-google-plus', '2020-08-15 21:30:22', 2),
('SUB0017', '0003', 'Land line', 'Land', 'land_line', '0', 'bongmap@gmail.com', 'fa fa-folder-open', '2020-08-15 21:30:22', 0),
('SUB0018', '0004', 'Item Land', 'Land', 'registerland', '0', 'bongmap@gmail.com', 'fa fa-folder-open', '2020-08-15 21:30:22', 1),
('SUB0019', '0004', 'Sell Land', 'admin', 'sale_land', '0', 'bongmap@gmail.com', 'fa fa-hand-o-right', '2020-08-15 21:30:22', 4),
('SUB0011', '0002', 'Reg Customer', 'pos', 'add_customer', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-20 13:02:45', 2),
('SUB0020', '0003', 'Setup branch', 'Setting', 'setupbranch', '0', 'bongmap@gmail.com', 'fa fa-hand-o-right', '2020-08-15 21:30:22', 0),
('SUB0002', '0002', 'Reg Product', 'pos', 'registerproduct', '0', 'IT.SYSTEM', '\'NULL\'', '2020-08-27 22:46:02', 1),
('SUB0004', '0006', 'Coffee Line', 'Coffee', 'coffee_line', '0', 'IT.SYSTEM', '\'NULL\'', '2020-12-13 09:27:46', 101),
('SUB0005', '0005', 'Income & Expend', 'Land', 'income_land', '0', 'IT.SYSTEM', '\'NULL\'', '2020-12-13 15:29:32', 0),
('SUB0012', '0002', 'Checking Product', 'pos', 'product_instock', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-23 14:16:14', 0),
('SUB0006', '0005', 'Tiller', 'Land', 'tiller_land', '0', 'IT.SYSTEM', '\'NULL\'', '2021-01-27 20:29:05', 2),
('SUB0007', '0003', 'POS Line', 'POS', 'pos_line', '0', 'IT.SYSTEM', '\'NULL\'', '2021-02-20 08:47:33', 10),
('SUB0008', '0002', 'Stock transfer', 'pos', 'pos_stock_transfer', '0', 'IT.SYSTEM', '\'NULL\'', '2021-02-20 09:40:55', 8),
('SUB0009', '0002', 'Count Stock', 'pos', 'pos_countstock', '0', 'IT.SYSTEM', '\'NULL\'', '2021-02-20 09:41:07', 7),
('SUB0010', '0002', 'Purchase order', 'pos', 'purchase_order', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-07 22:13:15', 9),
('SUB0001', '0002', 'Return POS Sale', 'pos', 'return_pos', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-28 12:27:20', 5),
('SUB0026', '0009', 'Product in stock', 'pos_report', 'rpt_pos_product_in_stock', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-28 13:26:32', 102),
('SUB0027', '0012', 'Acc-Income', 'Posacc', 'pos_income', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-29 13:52:50', 103),
('SUB0028', '0012', 'Acc-Expense', 'POS', 'pos_expense', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-31 10:12:59', NULL),
('SUB0029', '0003', 'User Profile', 'Setting', 'userprofile', '0', 'IT.SYSTEM', '\'NULL\'', '2021-03-31 22:26:09', NULL),
('SUB0030', '0015', 'Post product', 'post', 'post_product', '1', 'IT.SYSTEM', '\'NULL\'', '2021-04-12 11:05:54', NULL),
('SUB0031', '0009', 'POS sold out', 'pos_report', 'rpt_pos_sold_out', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-16 09:34:53', NULL),
('SUB0032', '0009', 'Expense', 'pos_report', 'rpt_pos_expense', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-16 11:40:26', NULL),
('SUB0033', '0009', 'Income', 'pos_report', 'rpt_pos_income', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-16 11:40:50', NULL),
('SUB0034', '0009', 'Purchase order', 'pos_report', 'rpt_pos_purchase', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-16 20:53:51', NULL),
('SUB0035', '0009', 'Count Stock', 'pos_report', 'rpt_pos_count_stock', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-17 07:50:51', NULL),
('SUB0036', '0009', 'Stock transfer', 'pos_report', 'rpt_pos_stock_transfer', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-17 09:26:41', NULL),
('SUB0037', '0009', 'Monthly Closing', 'pos_report', 'rpt_pos_monthly_closing', '0', 'IT.SYSTEM', '\'NULL\'', '2021-04-25 14:25:28', NULL),
('SUB0038', '0009', 'Return POS Sale', 'pos_report', 'rpt_pos_sold_out_return', '0', 'IT.SYSTEM', '\'NULL\'', '2021-05-23 11:31:06', NULL),
('SUB0039', '0006', 'Coffee item', 'Coffee', 'coffee_items', '0', 'IT.SYSTEM', '\'NULL\'', '2021-07-18 21:13:38', NULL),
('SUB0040', '0003', 'Permission Profile', 'pos', 'setup_permission', '0', 'IT.SYSTEM', '\'NULL\'', '2021-07-22 13:43:27', NULL),
('SUB0041', '0014', 'Quote', 'PostController', 'Quote', '0', 'IT.SYSTEM', '\'NULL\'', '2021-08-13 15:42:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `_testing`
--

CREATE TABLE `_testing` (
  `col` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `_testing`
--

INSERT INTO `_testing` (`col`) VALUES
(NULL),
(NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ajax_cruds`
--
ALTER TABLE `ajax_cruds`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coffee_tbl_line`
--
ALTER TABLE `coffee_tbl_line`
  ADD PRIMARY KEY (`line_id`,`branchcode`);

--
-- Indexes for table `coffee_tbl_products`
--
ALTER TABLE `coffee_tbl_products`
  ADD PRIMARY KEY (`pro_id`,`branchcode`);

--
-- Indexes for table `coffee_tbl_product_size`
--
ALTER TABLE `coffee_tbl_product_size`
  ADD PRIMARY KEY (`sysdocnum`,`branchcode`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gb_list_percent`
--
ALTER TABLE `gb_list_percent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gb_number_next_by_branch`
--
ALTER TABLE `gb_number_next_by_branch`
  ADD PRIMARY KEY (`branchcode`,`line_number`);

--
-- Indexes for table `gb_profile_by_branch`
--
ALTER TABLE `gb_profile_by_branch`
  ADD PRIMARY KEY (`profileid`,`branchcode`);

--
-- Indexes for table `gb_system_controls`
--
ALTER TABLE `gb_system_controls`
  ADD PRIMARY KEY (`sys_con_id`);

--
-- Indexes for table `gb_sys_branch`
--
ALTER TABLE `gb_sys_branch`
  ADD PRIMARY KEY (`branchcode`,`subofbranch`);

--
-- Indexes for table `gb_sys_contants`
--
ALTER TABLE `gb_sys_contants`
  ADD PRIMARY KEY (`con_name`);

--
-- Indexes for table `gb_sys_contant_fix`
--
ALTER TABLE `gb_sys_contant_fix`
  ADD PRIMARY KEY (`con_name`,`con_value`);

--
-- Indexes for table `gb_sys_users`
--
ALTER TABLE `gb_sys_users`
  ADD PRIMARY KEY (`id`,`branchcode`);

--
-- Indexes for table `gb_sys_user_info`
--
ALTER TABLE `gb_sys_user_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gb_tbl_currency`
--
ALTER TABLE `gb_tbl_currency`
  ADD PRIMARY KEY (`currencycode`);

--
-- Indexes for table `gb_tbl_permission`
--
ALTER TABLE `gb_tbl_permission`
  ADD PRIMARY KEY (`per_id`,`menu_id`,`pro_id`);

--
-- Indexes for table `gb_tbl_profile`
--
ALTER TABLE `gb_tbl_profile`
  ADD PRIMARY KEY (`pro_id`);

--
-- Indexes for table `kqr_admin_branch_office`
--
ALTER TABLE `kqr_admin_branch_office`
  ADD PRIMARY KEY (`branch_code`);

--
-- Indexes for table `kqr_admin_branch_sub_office`
--
ALTER TABLE `kqr_admin_branch_sub_office`
  ADD PRIMARY KEY (`sub_branch_code`,`branch_code`);

--
-- Indexes for table `kqr_admin_profile_user`
--
ALTER TABLE `kqr_admin_profile_user`
  ADD PRIMARY KEY (`pro_id`,`user_login_id`);

--
-- Indexes for table `kqr_land_constant`
--
ALTER TABLE `kqr_land_constant`
  ADD PRIMARY KEY (`con_name`);

--
-- Indexes for table `kqr_land_customers`
--
ALTER TABLE `kqr_land_customers`
  ADD PRIMARY KEY (`cus_id`);

--
-- Indexes for table `kqr_land_expend`
--
ALTER TABLE `kqr_land_expend`
  ADD PRIMARY KEY (`exp_id`,`branchcode`);

--
-- Indexes for table `kqr_land_items`
--
ALTER TABLE `kqr_land_items`
  ADD PRIMARY KEY (`item_id`,`branchcode`);

--
-- Indexes for table `kqr_land_register_items`
--
ALTER TABLE `kqr_land_register_items`
  ADD PRIMARY KEY (`rg_id`,`branchcode`);

--
-- Indexes for table `kqr_land_sale`
--
ALTER TABLE `kqr_land_sale`
  ADD PRIMARY KEY (`sal_id`,`branchcode`);

--
-- Indexes for table `kqr_land_sale_act`
--
ALTER TABLE `kqr_land_sale_act`
  ADD PRIMARY KEY (`act_id`,`branchcode`);

--
-- Indexes for table `kqr_sys_address`
--
ALTER TABLE `kqr_sys_address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `post_tbl_quotes`
--
ALTER TABLE `post_tbl_quotes`
  ADD PRIMARY KEY (`id`,`branchcode`);

--
-- Indexes for table `pos_tbl_count_stock`
--
ALTER TABLE `pos_tbl_count_stock`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_count_stock_detail`
--
ALTER TABLE `pos_tbl_count_stock_detail`
  ADD PRIMARY KEY (`sysdocnum`,`branchcode`);

--
-- Indexes for table `pos_tbl_customers`
--
ALTER TABLE `pos_tbl_customers`
  ADD PRIMARY KEY (`cus_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_customer_type`
--
ALTER TABLE `pos_tbl_customer_type`
  ADD PRIMARY KEY (`typ_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_document_file`
--
ALTER TABLE `pos_tbl_document_file`
  ADD PRIMARY KEY (`sysdonum`,`branchcode`);

--
-- Indexes for table `pos_tbl_expense`
--
ALTER TABLE `pos_tbl_expense`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_fee`
--
ALTER TABLE `pos_tbl_fee`
  ADD PRIMARY KEY (`sysnum`,`branchcode`);

--
-- Indexes for table `pos_tbl_income`
--
ALTER TABLE `pos_tbl_income`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_invoices`
--
ALTER TABLE `pos_tbl_invoices`
  ADD PRIMARY KEY (`inv_num`,`cus_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_invoice_return`
--
ALTER TABLE `pos_tbl_invoice_return`
  ADD PRIMARY KEY (`inv_num`,`cus_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_line`
--
ALTER TABLE `pos_tbl_line`
  ADD PRIMARY KEY (`line_id`);

--
-- Indexes for table `pos_tbl_payment_method`
--
ALTER TABLE `pos_tbl_payment_method`
  ADD PRIMARY KEY (`pay_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_products`
--
ALTER TABLE `pos_tbl_products`
  ADD PRIMARY KEY (`pro_id`,`branchcode`,`barcode`);

--
-- Indexes for table `pos_tbl_proline`
--
ALTER TABLE `pos_tbl_proline`
  ADD PRIMARY KEY (`line_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_pro_type`
--
ALTER TABLE `pos_tbl_pro_type`
  ADD PRIMARY KEY (`typ_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_purchase_details`
--
ALTER TABLE `pos_tbl_purchase_details`
  ADD PRIMARY KEY (`sysdonum`,`pur_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_purchase_order`
--
ALTER TABLE `pos_tbl_purchase_order`
  ADD PRIMARY KEY (`pur_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_stockouts`
--
ALTER TABLE `pos_tbl_stockouts`
  ADD PRIMARY KEY (`sto_num`,`branchcode`,`inv_num`);

--
-- Indexes for table `pos_tbl_stockout_return`
--
ALTER TABLE `pos_tbl_stockout_return`
  ADD PRIMARY KEY (`sto_num`,`branchcode`,`inv_num`);

--
-- Indexes for table `pos_tbl_stocks`
--
ALTER TABLE `pos_tbl_stocks`
  ADD PRIMARY KEY (`stk_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_stocktransfer`
--
ALTER TABLE `pos_tbl_stocktransfer`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_stocktransfer_detail`
--
ALTER TABLE `pos_tbl_stocktransfer_detail`
  ADD PRIMARY KEY (`sysdocnum`);

--
-- Indexes for table `pos_tbl_supplier`
--
ALTER TABLE `pos_tbl_supplier`
  ADD PRIMARY KEY (`sup_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_transactions`
--
ALTER TABLE `pos_tbl_transactions`
  ADD PRIMARY KEY (`sysdocnum`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_count_stock`
--
ALTER TABLE `pos_tbl_una_count_stock`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_count_stock_detail`
--
ALTER TABLE `pos_tbl_una_count_stock_detail`
  ADD PRIMARY KEY (`sysdocnum`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_document_file`
--
ALTER TABLE `pos_tbl_una_document_file`
  ADD PRIMARY KEY (`sysdonum`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_expense`
--
ALTER TABLE `pos_tbl_una_expense`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_income`
--
ALTER TABLE `pos_tbl_una_income`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_invoices`
--
ALTER TABLE `pos_tbl_una_invoices`
  ADD PRIMARY KEY (`inv_num`,`cus_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_invoice_return`
--
ALTER TABLE `pos_tbl_una_invoice_return`
  ADD PRIMARY KEY (`inv_num`,`cus_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_purchase_details`
--
ALTER TABLE `pos_tbl_una_purchase_details`
  ADD PRIMARY KEY (`sysdonum`,`pur_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_purchase_order`
--
ALTER TABLE `pos_tbl_una_purchase_order`
  ADD PRIMARY KEY (`pur_id`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_stockouts`
--
ALTER TABLE `pos_tbl_una_stockouts`
  ADD PRIMARY KEY (`sto_num`,`branchcode`,`inv_num`);

--
-- Indexes for table `pos_tbl_una_stockout_return`
--
ALTER TABLE `pos_tbl_una_stockout_return`
  ADD PRIMARY KEY (`sto_num`,`branchcode`,`inv_num`);

--
-- Indexes for table `pos_tbl_una_stocktransfer`
--
ALTER TABLE `pos_tbl_una_stocktransfer`
  ADD PRIMARY KEY (`tran_code`,`branchcode`);

--
-- Indexes for table `pos_tbl_una_stocktransfer_detail`
--
ALTER TABLE `pos_tbl_una_stocktransfer_detail`
  ADD PRIMARY KEY (`sysdocnum`,`branchcode`);

--
-- Indexes for table `tbl_land_tillers`
--
ALTER TABLE `tbl_land_tillers`
  ADD PRIMARY KEY (`tiller_num`,`branchcode`);

--
-- Indexes for table `tbl_main_left_menu`
--
ALTER TABLE `tbl_main_left_menu`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indexes for table `tbl_menu_permission`
--
ALTER TABLE `tbl_menu_permission`
  ADD PRIMARY KEY (`per_id`,`menu_id`);

--
-- Indexes for table `tbl_menu_permission_branch`
--
ALTER TABLE `tbl_menu_permission_branch`
  ADD PRIMARY KEY (`per_id`,`menu_id`,`profile_id`,`branchcode`);

--
-- Indexes for table `tbl_menu_permission_profile`
--
ALTER TABLE `tbl_menu_permission_profile`
  ADD PRIMARY KEY (`per_id`,`menu_id`,`profile_id`);

--
-- Indexes for table `tbl_sub_left_menu`
--
ALTER TABLE `tbl_sub_left_menu`
  ADD PRIMARY KEY (`subm_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ajax_cruds`
--
ALTER TABLE `ajax_cruds`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gb_list_percent`
--
ALTER TABLE `gb_list_percent`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
