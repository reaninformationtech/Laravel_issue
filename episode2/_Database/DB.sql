CREATE TABLE `tbl_left_menu` (
  `menu_id` varchar(45) NOT NULL,
  `menu_name` varchar(45) DEFAULT '''NULL''',
  `menu_inactive` varchar(10) DEFAULT '''NULL''',
  `menu_order` int(11) DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=156 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_left_menu`
--

INSERT INTO `tbl_left_menu` (`menu_id`, `menu_name`, `menu_inactive`, `menu_order`) VALUES
('0001', 'Super User', '0', 1),
('0002', 'POS System', '0', 2),
('0099', 'Setting', '0', 80),
('0004', 'Menu', '0', 3),
('0005', 'Accounting', '0', 4);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sub_left_menu`
--

CREATE TABLE `tbl_sub_left_menu` (
  `sub_id` varchar(45) NOT NULL,
  `menu_id` varchar(45) NOT NULL,
  `sub_name` varchar(45) DEFAULT '''NULL''',
  `sub_inactive` varchar(10) DEFAULT '''NULL''',
  `sub_order` int(11) DEFAULT NULL,
  `frmaction` varchar(100) DEFAULT NULL
) ENGINE=MyISAM AVG_ROW_LENGTH=156 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_sub_left_menu`
--

INSERT INTO `tbl_sub_left_menu` (`sub_id`, `menu_id`, `sub_name`, `sub_inactive`, `sub_order`, `frmaction`) VALUES
('S0001', '0001', 'Create Menu', '0', 0, 'create_menu'),
('S0002', '0002', 'Pos Menu', '0', 1, 'create_pos'),
('S0003', '0001', 'Create user', '0', 2, 'create_user');