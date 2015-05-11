INSERT INTO BPM_DD_TIN_TIPO_INPUT
(BPM_DD_TIN_ID, BPM_DD_TIN_CODIGO, BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, 
VERSION, USUARIOCREAR, FECHACREAR, BORRADO, BPM_DD_TIN_CLASE) 
(SELECT S_BPM_DD_TIN_TIPO_INPUT.NEXTVAL BPM_DD_TIN_ID,
'REDACC_DEM_BATCH' BPM_DD_TIN_CODIGO, 
BPM_DD_TIN_DESCRIPCION, BPM_DD_TIN_DESCRIPCION_LARGA, 
0 VERSION, 'MASIVO' USUARIOCREAR, SYSDATE FECHACREAR,  
0 BORRADO, BPM_DD_TIN_CLASE
FROM BPM_DD_TIN_TIPO_INPUT
WHERE BPM_DD_TIN_CODIGO = 'REDACC_DEM');

INSERT INTO BPM_TPI_TIPO_PROC_INPUT
(BPM_TPI_ID, DD_TPO_ID, BPM_DD_TAC_ID, BPM_DD_TIN_ID,
DD_INFORME_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC,
VERSION, USUARIOCREAR, FECHACREAR, 
BORRADO, BPM_TPI_NOMBRE_TRANSICION)
(SELECT S_BPM_TPI_TIPO_PROC_INPUT.NEXTVAL BPM_TPI_ID, 
DD_TPO_ID, BPM_DD_TAC_ID, 
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT WHERE BPM_DD_TIN_CODIGO = 'REDACC_DEM_BATCH') BPM_DD_TIN_ID,
DD_INFORME_ID, BPM_TPI_NODE_INC, BPM_TPI_NODE_EXC,
0 VERSION, 'MASIVO' USUARIOCREAR, SYSDATE FECHACREAR, 
0 BORRADO, BPM_TPI_NOMBRE_TRANSICION
FROM BPM_TPI_TIPO_PROC_INPUT
WHERE BPM_DD_TIN_ID IN
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT
WHERE BPM_DD_TIN_CODIGO = 'REDACC_DEM'));

INSERT INTO BPM_IDT_INPUT_DATOS
(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO,
VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT S_BPM_IDT_INPUT_DATOS.NEXTVAL BPM_IDT_ID, Q.*,
   0 VERSION, 'MASIVO' USUARIOCREAR, SYSDATE FECHACREAR, 0 BORRADO 
FROM (
SELECT TIN.*, DAT.* FROM 
(SELECT DISTINCT BPM_TPI_ID FROM BPM_TPI_TIPO_PROC_INPUT
WHERE BPM_DD_TIN_ID IN
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT
WHERE BPM_DD_TIN_CODIGO = 'REDACC_DEM_BATCH')) TIN,
(SELECT DISTINCT BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO 
FROM BPM_IDT_INPUT_DATOS
WHERE BPM_TPI_ID IN
(SELECT BPM_TPI_ID FROM BPM_TPI_TIPO_PROC_INPUT
WHERE BPM_DD_TIN_ID IN
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT
WHERE BPM_DD_TIN_CODIGO = 'REDACC_DEM'))) DAT
ORDER BY BPM_TPI_ID) Q;

INSERT INTO BPM_IDT_INPUT_DATOS
(BPM_IDT_ID, BPM_TPI_ID, BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO,
VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT S_BPM_IDT_INPUT_DATOS.NEXTVAL BPM_IDT_ID, Q.*,
   0 VERSION, 'MASIVO' USUARIOCREAR, SYSDATE FECHACREAR, 0 BORRADO 
FROM (
SELECT TIN.*, DAT.* FROM 
(SELECT DISTINCT BPM_TPI_ID FROM BPM_TPI_TIPO_PROC_INPUT
WHERE BPM_DD_TIN_ID IN
(SELECT BPM_DD_TIN_ID FROM BPM_DD_TIN_TIPO_INPUT
WHERE BPM_DD_TIN_CODIGO = 'REDACC_DEM_BATCH')) TIN,
(SELECT DISTINCT BPM_IDT_NOMBRE, BPM_IDT_GRUPO, BPM_IDT_DATO 
FROM BPM_IDT_INPUT_DATOS
WHERE BPM_IDT_NOMBRE = 'NUM_FILA' and BPM_IDT_GRUPO = 'generico' ) DAT
ORDER BY BPM_TPI_ID) Q;

COMMIT;