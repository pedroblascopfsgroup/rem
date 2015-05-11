USE mysql;

DROP SCHEMA pfs01;
DROP SCHEMA pfs02;
DROP SCHEMA pfsmaster;

CREATE SCHEMA pfsmaster;
CREATE SCHEMA pfs01;
CREATE SCHEMA pfs02;

GRANT ALL ON pfs01.* TO 'pfs01'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON pfsmaster.* TO 'pfs01'@'%' IDENTIFIED BY 'admin';

GRANT ALL ON pfs02.* TO 'pfs02'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON pfsmaster.* TO 'pfs02'@'%' IDENTIFIED BY 'admin';

GRANT ALL ON pfs01.* TO 'pfsmaster'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON pfs02.* TO 'pfsmaster'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON pfsmaster.* TO 'pfsmaster'@'%' IDENTIFIED BY 'admin';

GRANT FILE ON *.* TO pfs01;
GRANT FILE ON *.* TO pfs02;

DROP SCHEMA test_pfs01;
DROP SCHEMA test_pfs02;
DROP SCHEMA test_pfsmaster;

CREATE SCHEMA test_pfsmaster;
CREATE SCHEMA test_pfs01;
CREATE SCHEMA test_pfs02;

GRANT ALL ON test_pfs01.* TO 'test_pfs01'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON test_pfsmaster.* TO 'test_pfs01'@'%' IDENTIFIED BY 'admin';

GRANT ALL ON test_pfs02.* TO 'test_pfs02'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON test_pfsmaster.* TO 'test_pfs02'@'%' IDENTIFIED BY 'admin';

GRANT ALL ON test_pfs01.* TO 'test_pfsmaster'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON test_pfs02.* TO 'test_pfsmaster'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON test_pfsmaster.* TO 'test_pfsmaster'@'%' IDENTIFIED BY 'admin';

GRANT FILE ON *.* TO test_pfs01;
GRANT FILE ON *.* TO test_pfs02;

COMMIT;