OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/ACTIVO_ADJ_JUDICIAL.dat'
BADFILE './CTLs_DATs/bad/ACTIVO_ADJ_JUDICIAL.bad'
DISCARDFILE './CTLs_DATs/rejects/ACTIVO_ADJ_JUDICIAL.bad'
INTO TABLE REM01.MIG_ADJ_JUDICIAL
TRUNCATE
TRAILING NULLCOLS
(
ACT_NUMERO_ACTIVO POSITION(1:17) INTEGER EXTERNAL  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
ENTIDAD_EJECUTANTE POSITION(18:37) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:ENTIDAD_EJECUTANTE),';',' '), '\"',''),'''','')",
ESTADO_ADJUDICACION POSITION(38:57) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:ESTADO_ADJUDICACION),';',' '), '\"',''),'''','')",
AJD_FECHA_ADJUDICACION POSITION(58:65) DATE 'YYYYMMDD'  "REPLACE(:AJD_FECHA_ADJUDICACION, '00000000', '')",
AJD_FECHA_DECRETO_FIRME POSITION(66:73) DATE 'YYYYMMDD'  "REPLACE(:AJD_FECHA_DECRETO_FIRME, '00000000', '')",
AJD_FECHA_REA_POSESION POSITION(74:81) DATE 'YYYYMMDD'  "REPLACE(:AJD_FECHA_REA_POSESION, '00000000', '')",
AJD_IMPORTE_ADJUDICACION POSITION(82:98) INTEGER EXTERNAL  "CASE WHEN (:AJD_IMPORTE_ADJUDICACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AJD_IMPORTE_ADJUDICACION,1,15)||','||SUBSTR(:AJD_IMPORTE_ADJUDICACION,16,2)),';',' '), '\"',''),'''','')) END",
JUZGADO POSITION(99:148) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:JUZGADO),';',' '), '\"',''),'''','')",
PLAZA_JUZGADO POSITION(149:178) CHAR  NULLIF(PLAZA_JUZGADO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:PLAZA_JUZGADO),';',' '), '\"',''),'''','')",
AJD_NUM_AUTO POSITION(179:228) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:AJD_NUM_AUTO),';',' '), '\"',''),'''','')",
AJD_PROCURADOR POSITION(229:328) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:AJD_PROCURADOR),';',' '), '\"',''),'''','')",
AJD_LETRADO POSITION(329:428) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:AJD_LETRADO),';',' '), '\"',''),'''','')",
AJD_ID_ASUNTO POSITION(429:445) INTEGER EXTERNAL  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AJD_ID_ASUNTO),';',' '), '\"',''),'''',''),2,16))",
AJD_EXP_DEF_TESTI POSITION(446:450) INTEGER EXTERNAL  NULLIF(AJD_EXP_DEF_TESTI=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AJD_EXP_DEF_TESTI),';',' '), '\"',''),'''',''),2,4))",
BIE_ADJ_F_DECRETO_N_FIRME POSITION(451:458) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_DECRETO_N_FIRME=BLANKS) "REPLACE(:BIE_ADJ_F_DECRETO_N_FIRME, '00000000', '')",
BIE_ADJ_F_INSCRIP_TITULO POSITION(459:466) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_INSCRIP_TITULO, '00000000', '')",
BIE_ADJ_F_ENVIO_ADICION POSITION(467:474) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_ENVIO_ADICION=BLANKS) "REPLACE(:BIE_ADJ_F_ENVIO_ADICION, '00000000', '')",
BIE_ADJ_F_SOL_POSESION POSITION(475:482) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_SOL_POSESION=BLANKS) "REPLACE(:BIE_ADJ_F_SOL_POSESION, '00000000', '')",
BIE_ADJ_F_SEN_POSESION POSITION(483:490) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_SEN_POSESION=BLANKS) "REPLACE(:BIE_ADJ_F_SEN_POSESION, '00000000', '')",
BIE_ADJ_F_REA_POSESION POSITION(491:498) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_REA_POSESION, '00000000', '')",
BIE_ADJ_F_SOL_LANZAMIENTO POSITION(499:506) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_SOL_LANZAMIENTO=BLANKS) "REPLACE(:BIE_ADJ_F_SOL_LANZAMIENTO, '00000000', '')",
BIE_ADJ_F_SEN_LANZAMIENTO POSITION(507:514) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_SEN_LANZAMIENTO=BLANKS) "REPLACE(:BIE_ADJ_F_SEN_LANZAMIENTO, '00000000', '')",
BIE_ADJ_F_REA_LANZAMIENTO POSITION(515:522) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_REA_LANZAMIENTO=BLANKS) "REPLACE(:BIE_ADJ_F_REA_LANZAMIENTO, '00000000', '')",
BIE_ADJ_F_SOL_MORATORIA POSITION(523:530) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_SOL_MORATORIA, '00000000', '')",
BIE_ADJ_F_RES_MORATORIA POSITION(531:538) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_RES_MORATORIA, '00000000', '')",
BIE_ADJ_F_CONTRATO_ARREN POSITION(539:546) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_CONTRATO_ARREN, '00000000', '')",
BIE_ADJ_F_CAMBIO_CERRADURA POSITION(547:554) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_CAMBIO_CERRADURA=BLANKS) "REPLACE(:BIE_ADJ_F_CAMBIO_CERRADURA, '00000000', '')",
BIE_ADJ_F_ENVIO_LLAVES POSITION(555:562) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_ENVIO_LLAVES=BLANKS) "REPLACE(:BIE_ADJ_F_ENVIO_LLAVES, '00000000', '')",
BIE_ADJ_F_RECEP_DEPOSITARIO POSITION(563:570) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_RECEP_DEPOSITARIO=BLANKS) "REPLACE(:BIE_ADJ_F_RECEP_DEPOSITARIO, '00000000', '')",
BIE_ADJ_F_ENVIO_DEPOSITARIO POSITION(571:578) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_ENVIO_DEPOSITARIO=BLANKS) "REPLACE(:BIE_ADJ_F_ENVIO_DEPOSITARIO, '00000000', '')",
BIE_ADJ_OCUPADO POSITION(579:580) INTEGER EXTERNAL  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_OCUPADO),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_POSIBLE_POSESION POSITION(581:582) INTEGER EXTERNAL  NULLIF(BIE_ADJ_POSIBLE_POSESION=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_POSIBLE_POSESION),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_OCUPANTES_DILIGENCIA POSITION(583:584) INTEGER EXTERNAL  NULLIF(BIE_ADJ_OCUPANTES_DILIGENCIA=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_OCUPANTES_DILIGENCIA),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_LANZAMIENTO_NECES POSITION(585:586) INTEGER EXTERNAL  NULLIF(BIE_ADJ_LANZAMIENTO_NECES=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_LANZAMIENTO_NECES),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_ENTREGA_VOLUNTARIA POSITION(587:588) INTEGER EXTERNAL  NULLIF(BIE_ADJ_ENTREGA_VOLUNTARIA=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_ENTREGA_VOLUNTARIA),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_NECESARIA_FUERA_PUB POSITION(589:590) INTEGER EXTERNAL  NULLIF(BIE_ADJ_NECESARIA_FUERA_PUB=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NECESARIA_FUERA_PUB),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_EXISTE_INQUILINO POSITION(591:592) INTEGER EXTERNAL  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_EXISTE_INQUILINO),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_LLAVES_NECESARIAS POSITION(593:594) INTEGER EXTERNAL  NULLIF(BIE_ADJ_LLAVES_NECESARIAS=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_LLAVES_NECESARIAS),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_GESTORIA_ADJUDIC POSITION(595:611) INTEGER EXTERNAL  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_GESTORIA_ADJUDIC),';',' '), '\"',''),'''',''),2,16))",
BIE_ADJ_NOMBRE_ARRENDATARIO POSITION(612:661) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOMBRE_ARRENDATARIO),';',' '), '\"',''),'''','')",
BIE_ADJ_NOMBRE_DEPOSITARIO POSITION(662:711) CHAR  NULLIF(BIE_ADJ_NOMBRE_DEPOSITARIO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOMBRE_DEPOSITARIO),';',' '), '\"',''),'''','')",
BIE_ADJ_NOMBRE_DEPOSITARIO_F POSITION(712:761) CHAR  NULLIF(BIE_ADJ_NOMBRE_DEPOSITARIO_F=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOMBRE_DEPOSITARIO_F),';',' '), '\"',''),'''','')",
DD_EAD_ID POSITION(762:781) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:DD_EAD_ID),';',' '), '\"',''),'''','')",
DD_SIT_ID POSITION(782:801) CHAR  "REPLACE(REPLACE(REPLACE(TRIM(:DD_SIT_ID),';',' '), '\"',''),'''','')",
DD_FAV_ID POSITION(802:821) CHAR  NULLIF(DD_FAV_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_FAV_ID),';',' '), '\"',''),'''','')",
BIE_ADJ_F_RECEP_DEPOSITARIO_F POSITION(822:829) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_RECEP_DEPOSITARIO_F=BLANKS) "REPLACE(:BIE_ADJ_F_RECEP_DEPOSITARIO_F, '00000000', '')",
DD_TFO_ID POSITION(830:849) CHAR  NULLIF(DD_TFO_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_TFO_ID),';',' '), '\"',''),'''','')",
BIE_ADJ_REQ_SUBSANACION POSITION(850:851) INTEGER EXTERNAL  NULLIF(BIE_ADJ_REQ_SUBSANACION=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_REQ_SUBSANACION),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_NOTIF_DEMANDADOS POSITION(852:853) INTEGER EXTERNAL  NULLIF(BIE_ADJ_NOTIF_DEMANDADOS=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOTIF_DEMANDADOS),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_F_REV_PROP_CAN POSITION(854:861) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_REV_PROP_CAN, '00000000', '')",
BIE_ADJ_F_PROP_CAN POSITION(862:869) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_PROP_CAN, '00000000', '')",
BIE_ADJ_F_REV_CARGAS POSITION(870:877) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_REV_CARGAS, '00000000', '')",
BIE_ADJ_F_PRES_INS_ECO POSITION(878:885) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_PRES_INS_ECO, '00000000', '')",
BIE_ADJ_F_PRES_INS POSITION(886:893) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_PRES_INS, '00000000', '')",
BIE_ADJ_F_CAN_REG_ECO POSITION(894:901) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_CAN_REG_ECO, '00000000', '')",
BIE_ADJ_F_CAN_REG POSITION(902:909) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_CAN_REG, '00000000', '')",
BIE_ADJ_F_CAN_ECO POSITION(910:917) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_CAN_ECO, '00000000', '')",
BIE_ADJ_F_LIQUIDACION POSITION(918:925) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_LIQUIDACION, '00000000', '')",
BIE_ADJ_F_RECEPCION POSITION(926:933) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_RECEPCION, '00000000', '')",
BIE_ADJ_F_CANCELACION POSITION(934:941) DATE 'YYYYMMDD'  "REPLACE(:BIE_ADJ_F_CANCELACION, '00000000', '')",
BIE_ADJ_IMPORTE_ADJUDICACION POSITION(942:958) INTEGER EXTERNAL  "CASE WHEN (:BIE_ADJ_IMPORTE_ADJUDICACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_IMPORTE_ADJUDICACION,1,15)||','||SUBSTR(:BIE_ADJ_IMPORTE_ADJUDICACION,16,2)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_CESION_REMATE POSITION(959:960) INTEGER EXTERNAL  "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_CESION_REMATE),';',' '), '\"',''),'''',''),2,1))",
BIE_ADJ_CESION_REMATE_IMP POSITION(961:977) INTEGER EXTERNAL  NULLIF(BIE_ADJ_CESION_REMATE_IMP=BLANKS) "CASE WHEN (:BIE_ADJ_CESION_REMATE_IMP) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_CESION_REMATE_IMP,1,15)||','||SUBSTR(:BIE_ADJ_CESION_REMATE_IMP,16,2)),';',' '), '\"',''),'''','')) END",
DD_DAD_ID POSITION(978:997) CHAR  NULLIF(DD_DAD_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_DAD_ID),';',' '), '\"',''),'''','')",
BIE_ADJ_F_CONTABILIDAD POSITION(998:1005) DATE 'YYYYMMDD'  NULLIF(BIE_ADJ_F_CONTABILIDAD=BLANKS) "REPLACE(:BIE_ADJ_F_CONTABILIDAD, '00000000', '')",
BIE_ADJ_POSTORES POSITION(1006:1007) INTEGER EXTERNAL  NULLIF(BIE_ADJ_POSTORES=BLANKS) "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_POSTORES),';',' '), '\"',''),'''',''),2,1))",
VALIDACION CONSTANT "0")
