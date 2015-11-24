--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hcj
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Borrado lógico de los documentos que no se utilizan en Haya-Cajamar 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
  
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con el borrado lógico en DD_TFA_FICHERO_ADJUNTO de los documentos con código ''EJUZTBS'', ''FSSB'', ''FSSF'', ''INFFIS'', ''PSSB'', ''RSAR'', ''RSARSI'', ''ACTJUNACR'', ''AACO'', ''AAPLIQ'', ''AACONV'', ''AUTCONCON'', ''ADCO'', ''ASDJM'', ''AUTORF'', ''AREDI'', ''AUTORE'', ''BOE'', ''CON'', ''CNAUAP'', ''DTCCE'', ''DEINC'' , ''ESALEG'' , ''ECC'' , ''ESI'' , ''EODI'' , ''EORC'' , ''EOSC'' , ''ESSORE'' , ''ESCJUZ'' , ''ESC'' , ''EXT'' , ''IACPAC'' , ''INFAC'' , ''INFPRO'' , ''INFRENCUE'' , ''INACPC'' , ''INFADMCON'' , ''INFLETRADO'' , ''INFLFL'' , ''IPAC'' , ''INFTC'' , ''INFVL'' , ''INTDEM'' , ''LIC'' , ''OCO'' , ''PLALIQ'' , ''POL'' , ''PRAC'' , ''PCTER'' , ''PREPCO'' , ''P5BIS'' , ''REAC'' , ''RECA'' , ''REFC'' , ''RESADE'' , ''REAFC'' , ''REDIT'' , ''RESJUD'' , ''REACHA'' , ''RESJUZ'' , ''RSANSU'' , ''RSCOPR'' , ''RSFSCO'' , ''RSISDI'' , ''RSINFC'' , ''RSINPA'' , ''RSIPAC'' , ''RSPRAL'' , ''RSPPAL'' , ''RSPCCA'' , ''TDAC'' , ''PSUSB'' , ''RSARINE'' , ''RSARE''');  
  -- LOOP Insertando valores en dd_tfa_fichero_adjunto
  UPDATE #ESQUEMA#.DD_TFA_FICHERO_ADJUNTO tfa
	SET tfa.borrado          = 1,
	  tfa.usuarioborrar      = 'DD',
	  tfa.fechaborrar        = SYSDATE
	WHERE tfa.dd_tfa_codigo IN ('EJUZTBS', 'FSSB', 'FSSF', 'INFFIS', 'PSSB', 'RSAR', 'RSARSI', 'ACTJUNACR', 'AACO', 'AAPLIQ', 'AACONV', 'AUTCONCON', 'ADCO', 'ASDJM', 'AUTORF', 'AREDI', 'AUTORE', 'BOE', 'CON', 'CNAUAP', 'DTCCE', 'DEINC' , 'ESALEG' , 'ECC' , 'ESI' , 'EODI' , 'EORC' , 'EOSC' , 'ESSORE' , 'ESCJUZ' , 'ESC' , 'EXT' , 'IACPAC' , 'INFAC' , 'INFPRO' , 'INFRENCUE' , 'INACPC' , 'INFADMCON' , 'INFLETRADO' , 'INFLFL' , 'IPAC' , 'INFTC' , 'INFVL' , 'INTDEM' , 'LIC' , 'OCO' , 'PLALIQ' , 'POL' , 'PRAC' , 'PCTER' , 'PREPCO' , 'P5BIS' , 'REAC' , 'RECA' , 'REFC' , 'RESADE' , 'REAFC' , 'REDIT' , 'RESJUD' , 'REACHA' , 'RESJUZ' , 'RSANSU' , 'RSCOPR' , 'RSFSCO' , 'RSISDI' , 'RSINFC' , 'RSINPA' , 'RSIPAC' , 'RSPRAL' , 'RSPPAL' , 'RSPCCA' , 'TDAC' , 'PSUSB' , 'RSARINE' , 'RSARE' );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] #ESQUEMA#.dd_tfa_fichero_adjunto... Borrado lógico finalizado');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
