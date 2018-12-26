--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2052
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-2052'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	TIPO_TARIFA_CODIGO | TIPO_TRABAJO_CODIGO | TIPO_SUBTRABAJO_CODIGO | CARTERA_CODIGO | PRECIO_UNITARIO | UNIDAD_MEDIDA
   			T_TIPO_DATA('0001APE',     '03',     '26',     '08',     '21.50',     '€/ud'),
			T_TIPO_DATA('0002APE',     '03',     '26',     '08',     '21.00',     '€/ud'),
			T_TIPO_DATA('0003APE',     '03',     '26',     '08',     '21.00',     '€/ud'),
			T_TIPO_DATA('0001CDB',     '03',     '26',     '08',     '50.31',     '€/ud'),
			T_TIPO_DATA('0002CDB',     '03',     '26',     '08',     '61.90',     '€/ud'),
			T_TIPO_DATA('0003CDB',     '03',     '26',     '08',     '33.01',     '€/ud'),
			T_TIPO_DATA('0004CDB',     '03',     '26',     '08',     '20.00',     '€/ud'),
			T_TIPO_DATA('0005CDB',     '03',     '26',     '08',     '33.60',     '€/ud'),
			T_TIPO_DATA('0006CDB',     '03',     '26',     '08',     '24.40',     '€/ud'),
			T_TIPO_DATA('0007CDB',     '03',     '26',     '08',     '21.50',     '€/ud'),
			T_TIPO_DATA('0001GNL',     '03',     '61',     '08',     '3.40',     '€/ud'),
			T_TIPO_DATA('0002GNL',     '03',     '61',     '08',     '4.30',     '€/ud'),
			T_TIPO_DATA('0003GNL',     '03',     '61',     '08',     '1.80',     '€/ud'),
			T_TIPO_DATA('0001LMO',     '03',     '29',     '08',     '37.90',     '€/ud'),
			T_TIPO_DATA('0002LMO',     '03',     '29',     '08',     '45.61',     '€/ud'),
			T_TIPO_DATA('0003LMO',     '03',     '29',     '08',     '59.10',     '€/ud'),
			T_TIPO_DATA('0004LMO',     '03',     '29',     '08',     '69.71',     '€/ud'),
			T_TIPO_DATA('0005LMO',     '03',     '29',     '08',     '0.71',     '€/ud'),
			T_TIPO_DATA('0001LGF',     '03',     '29',     '08',     '48.20',     '€/ud'),
			T_TIPO_DATA('0002LGF',     '03',     '29',     '08',     '56.00',     '€/ud'),
			T_TIPO_DATA('0003LGF',     '03',     '29',     '08',     '64.80',     '€/ud'),
			T_TIPO_DATA('0004LGF',     '03',     '29',     '08',     '1.11',     '€/m2'),
			T_TIPO_DATA('0005LGF',     '03',     '29',     '08',     '0.50',     '€/m2'),
			T_TIPO_DATA('0001OTL',     '03',     '29',     '08',     '36.00',     '€/ud'),
			T_TIPO_DATA('0002OTL',     '03',     '29',     '08',     '74.91',     '€/ud'),
			T_TIPO_DATA('0003OTL',     '03',     '29',     '08',     '114.00',     '€/ud'),
			T_TIPO_DATA('0004OTL',     '03',     '29',     '08',     '4.06',     '€/m2'),
			T_TIPO_DATA('0005OTL',     '03',     '29',     '08',     '9.00',     '€/ud'),
			T_TIPO_DATA('0006OTL',     '03',     '29',     '08',     '6.11',     '€/ud'),
			T_TIPO_DATA('0007OTL',     '03',     '29',     '08',     '3.69',     '€/ud'),
			T_TIPO_DATA('0008OTL',     '03',     '29',     '08',     '4.89',     '€/ml'),
			T_TIPO_DATA('0001ASS',     '03',     '32',     '08',     '0.65',     '€/ud'),
			T_TIPO_DATA('0002ASS',     '03',     '32',     '08',     '0.65',     '€/ud'),
			T_TIPO_DATA('0003ASS',     '03',     '32',     '08',     '0.60',     '€/ud'),
			T_TIPO_DATA('0004ASS',     '03',     '32',     '08',     '0.45',     '€/ud'),
			T_TIPO_DATA('0005ASS',     '03',     '32',     '08',     '0.30',     '€/ud'),
			T_TIPO_DATA('0006ASS',     '03',     '32',     '08',     '0.28',     '€/ud'),
			T_TIPO_DATA('0007ASS',     '03',     '32',     '08',     '0.10',     '€/m2'),
			T_TIPO_DATA('0008ASS',     '03',     '32',     '08',     '32.11',     '€/m2'),
			T_TIPO_DATA('0009ASS',     '03',     '32',     '08',     '30.00',     '€/m2'),
			T_TIPO_DATA('0010ASS',     '03',     '32',     '08',     '26.11',     '€/m2'),
			T_TIPO_DATA('0011ASS',     '03',     '32',     '08',     '20.31',     '€/m2'),
			T_TIPO_DATA('0012ASS',     '03',     '32',     '08',     '20.10',     '€/m2'),
			T_TIPO_DATA('0013ASS',     '03',     '32',     '08',     '18.70',     '€/m2'),
			T_TIPO_DATA('0014ASS',     '03',     '32',     '08',     '21.60',     '€/m2'),
			T_TIPO_DATA('0015ASS',     '03',     '32',     '08',     '20.31',     '€/m2'),
			T_TIPO_DATA('0016ASS',     '03',     '32',     '08',     '19.01',     '€/m2'),
			T_TIPO_DATA('0017ASS',     '03',     '32',     '08',     '144.80',     '€/ud'),
			T_TIPO_DATA('0018ASS',     '03',     '32',     '08',     '331.71',     '€/ud'),
			T_TIPO_DATA('0019ASS',     '03',     '32',     '08',     '13.31',     '€/ml'),
			T_TIPO_DATA('0020ASS',     '03',     '32',     '08',     '15.70',     '€/ml'),
			T_TIPO_DATA('0021ASS',     '03',     '32',     '08',     '13.20',     '€/ml'),
			T_TIPO_DATA('0022ASS',     '03',     '32',     '08',     '15.01',     '€/ml'),
			T_TIPO_DATA('0001DDV',     '03',     '66',     '08',     '122.40',     '€/ud'),
			T_TIPO_DATA('0002DDV',     '03',     '66',     '08',     '236.00',     '€/ud'),
			T_TIPO_DATA('0003DDV',     '03',     '66',     '08',     '148.75',     '€/ud'),
			T_TIPO_DATA('0004DDV',     '03',     '66',     '08',     '148.75',     '€/ud'),
			T_TIPO_DATA('0005DDV',     '03',     '66',     '08',     '110.26',     '€/ud'),
			T_TIPO_DATA('0006DDV',     '03',     '66',     '08',     '143.75',     '€/ud'),
			T_TIPO_DATA('0007DDV',     '03',     '66',     '08',     '0.40',     '€/ud'),
			T_TIPO_DATA('0008DDV',     '03',     '66',     '08',     '0.40',     '€/m2'),
			T_TIPO_DATA('0009DDV',     '03',     '66',     '08',     '32.40',     '€/ud'),
			T_TIPO_DATA('0001VEM',     '03',     '28',     '08',     '91.00',     '€/ud'),
			T_TIPO_DATA('0002VEM',     '03',     '28',     '08',     '90.00',     '€/ud'),
			T_TIPO_DATA('0003VEM',     '03',     '28',     '08',     '44.80',     '€/ud'),
			T_TIPO_DATA('0004VEM',     '03',     '28',     '08',     '27.10',     '€/ud'),
			T_TIPO_DATA('0005VEM',     '03',     '28',     '08',     '26.90',     '€/ud'),
			T_TIPO_DATA('0001LAS',     '02',     '25',     '08',     '115.00',     '€/ud'),
			T_TIPO_DATA('0002LAS',     '02',     '25',     '08',     '115.00',     '€/ud'),
			T_TIPO_DATA('0003LAS',     '02',     '23',     '08',     '275.00',     '€/ud'),
			T_TIPO_DATA('0004LAS',     '02',     '23',     '08',     '146.63',     '€/ud'),
			T_TIPO_DATA('0005LAS',     '02',     '24',     '08',     '100.94',     '€/ud'),
			T_TIPO_DATA('0006LAS',     '02',     '23',     '08',     '183.80',     '€/ud'),
			T_TIPO_DATA('0007LAS',     '02',     '22',     '08',     '69.00',     '€/ud'),
			T_TIPO_DATA('0008LAS',     '02',     '24',     '08',     '237.50',     '€/ud'),
			T_TIPO_DATA('0009LAS',     '02',     '20',     '08',     '198.69',     '€/ud'),
			T_TIPO_DATA('0010LAS',     '02',     '19',     '08',     '122.19',     '€/ud'),
			T_TIPO_DATA('0011LAS',     '02',     '14',     '08',     '34.00',     '€/ud'),
			T_TIPO_DATA('0012LAS',     '02',     '18',     '08',     '118.75',     '€/ud'),
			T_TIPO_DATA('0013LAS',     '02',     '18',     '08',     '357.50',     '€/ud'),
			T_TIPO_DATA('0014LAS',     '02',     '18',     '08',     '467.50',     '€/ud'),
			T_TIPO_DATA('0015LAS',     '02',     '18',     '08',     '275.00',     '€/ud'),
			T_TIPO_DATA('0016LAS',     '02',     '18',     '08',     '187.00',     '€/ud'),
			T_TIPO_DATA('0017LAS',     '02',     '18',     '08',     '385.00',     '€/ud'),
			T_TIPO_DATA('0018LAS',     '02',     '14',     '08',     '107.80',     '€/ud'),
			T_TIPO_DATA('0019LAS',     '02',     '14',     '08',     '151.80',     '€/ud'),
			T_TIPO_DATA('0020LAS',     '02',     '14',     '08',     '335.00',     '€/ud'),
			T_TIPO_DATA('0021LAS',     '02',     '14',     '08',     '406.25',     '€/ud'),
			T_TIPO_DATA('0001CSP',     '03',     '72',     '08',     '42.81',     '€/ud'),
			T_TIPO_DATA('0002CSP',     '03',     '72',     '08',     '174.61',     '€/ud'),
			T_TIPO_DATA('0003CSP',     '03',     '72',     '08',     '7.60',     '€/ud'),
			T_TIPO_DATA('0004CSP',     '03',     '72',     '08',     '103.70',     '€/ud'),
			T_TIPO_DATA('0005CSP',     '03',     '72',     '08',     '57.80',     '€/ud'),
			T_TIPO_DATA('0006CSP',     '03',     '72',     '08',     '171.71',     '€/ud'),
			T_TIPO_DATA('0007CSP',     '03',     '72',     '08',     '88.01',     '€/ud'),
			T_TIPO_DATA('0008CSP',     '03',     '72',     '08',     '294.50',     '€/ud'),
			T_TIPO_DATA('0001RMS',     '03',     '121',     '08',     '19.21',     '€/m2'),
			T_TIPO_DATA('0002RMS',     '03',     '121',     '08',     '19.80',     '€/m2'),
			T_TIPO_DATA('0003RMS',     '03',     '121',     '08',     '19.31',     '€/m2'),
			T_TIPO_DATA('0004RMS',     '03',     '121',     '08',     '20.10',     '€/m2'),
			T_TIPO_DATA('0005RMS',     '03',     '121',     '08',     '16.80',     '€/m2'),
			T_TIPO_DATA('0006RMS',     '03',     '121',     '08',     '20.10',     '€/m2'),
			T_TIPO_DATA('0007RMS',     '03',     '121',     '08',     '19.80',     '€/ud'),
			T_TIPO_DATA('0008RMS',     '03',     '121',     '08',     '8.01',     '€/ml'),
			T_TIPO_DATA('0009RMS',     '03',     '121',     '08',     '13.10',     '€ml'),
			T_TIPO_DATA('0001PTA',     '03',     '122',     '08',     '642.80',     '€/ud'),
			T_TIPO_DATA('0002PTA',     '03',     '122',     '08',     '786.50',     '€/ud'),
			T_TIPO_DATA('0003PTA',     '03',     '122',     '08',     '908.20',     '€/ud'),
			T_TIPO_DATA('0004PTA',     '03',     '122',     '08',     '970.89',     '€/ud'),
			T_TIPO_DATA('0005PTA',     '03',     '122',     '08',     '3.71',     '€/ud'),
			T_TIPO_DATA('0006PTA',     '03',     '122',     '08',     '2.21',     '€/m2'),
			T_TIPO_DATA('0007PTA',     '03',     '122',     '08',     '28.00',     '€/m2'),
			T_TIPO_DATA('0008PTA',     '03',     '122',     '08',     '21.81',     '€/h'),
			T_TIPO_DATA('0001CPA',     '03',     '123',     '08',     '124.90',     '€/ud'),
			T_TIPO_DATA('0002CPA',     '03',     '123',     '08',     '131.90',     '€/ud'),
			T_TIPO_DATA('0003CPA',     '03',     '123',     '08',     '76.16',     '€/ud'),
			T_TIPO_DATA('0004CPA',     '03',     '123',     '08',     '41.20',     '€/ud'),
			T_TIPO_DATA('0005CPA',     '03',     '123',     '08',     '28.20',     '€/ud'),
			T_TIPO_DATA('0001FTA',     '03',     '124',     '08',     '105.90',     '€/ud'),
			T_TIPO_DATA('0002FTA',     '03',     '124',     '08',     '195.18',     '€/ud'),
			T_TIPO_DATA('0003FTA',     '03',     '124',     '08',     '87.35',     '€/ud'),
			T_TIPO_DATA('0004FTA',     '03',     '124',     '08',     '121.13',     '€/ud'),
			T_TIPO_DATA('0005FTA',     '03',     '124',     '08',     '59.31',     '€/ud'),
			T_TIPO_DATA('0006FTA',     '03',     '124',     '08',     '72.24',     '€/ud'),
			T_TIPO_DATA('0007FTA',     '03',     '124',     '08',     '85.16',     '€/ud'),
			T_TIPO_DATA('0008FTA',     '03',     '124',     '08',     '62.69',     '€/ud'),
			T_TIPO_DATA('0009FTA',     '03',     '124',     '08',     '67.35',     '€/ud'),
			T_TIPO_DATA('0010FTA',     '03',     '124',     '08',     '60.25',     '€/ud'),
			T_TIPO_DATA('0011FTA',     '03',     '124',     '08',     '74.63',     '€/ud'),
			T_TIPO_DATA('0012FTA',     '03',     '124',     '08',     '88.63',     '€/ud'),
			T_TIPO_DATA('0013FTA',     '03',     '124',     '08',     '130.63',     '€/ud'),
			T_TIPO_DATA('0014FTA',     '03',     '124',     '08',     '81.35',     '€/ud'),
			T_TIPO_DATA('0015FTA',     '03',     '124',     '08',     '127.65',     '€/ud'),
			T_TIPO_DATA('0016FTA',     '03',     '124',     '08',     '144.38',     '€/ud'),
			T_TIPO_DATA('0017FTA',     '03',     '124',     '08',     '194.55',     '€/ud'),
			T_TIPO_DATA('0018FTA',     '03',     '124',     '08',     '152.98',     '€/ud'),
			T_TIPO_DATA('0019FTA',     '03',     '124',     '08',     '152.98',     '€/ud'),
			T_TIPO_DATA('0020FTA',     '03',     '124',     '08',     '114.00',     '€/ud'),
			T_TIPO_DATA('0021FTA',     '03',     '124',     '08',     '75.63',     '€/ud'),
			T_TIPO_DATA('0022FTA',     '03',     '124',     '08',     '95.25',     '€/ud'),
			T_TIPO_DATA('0023FTA',     '03',     '124',     '08',     '69.50',     '€/ud'),
			T_TIPO_DATA('0024FTA',     '03',     '124',     '08',     '64.23',     '€/ud'),
			T_TIPO_DATA('0025FTA',     '03',     '124',     '08',     '60.23',     '€/ud'),
			T_TIPO_DATA('0026FTA',     '03',     '124',     '08',     '27.29',     '€/ud'),
			T_TIPO_DATA('0027FTA',     '03',     '124',     '08',     '30.70',     '€/ud'),
			T_TIPO_DATA('0028FTA',     '03',     '124',     '08',     '66.13',     '€/ud'),
			T_TIPO_DATA('0029FTA',     '03',     '124',     '08',     '34.39',     '€/ud'),
			T_TIPO_DATA('0030FTA',     '03',     '124',     '08',     '35.51',     '€/ud'),
			T_TIPO_DATA('0031FTA',     '03',     '124',     '08',     '35.51',     '€/ud'),
			T_TIPO_DATA('0032FTA',     '03',     '124',     '08',     '140.76',     '€/ud'),
			T_TIPO_DATA('0033FTA',     '03',     '124',     '08',     '56.63',     '€/ud'),
			T_TIPO_DATA('0034FTA',     '03',     '124',     '08',     '26.13',     '€/ud'),
			T_TIPO_DATA('0035FTA',     '03',     '124',     '08',     '187.50',     '€/ud'),
			T_TIPO_DATA('0036FTA',     '03',     '124',     '08',     '97.75',     '€/ud'),
			T_TIPO_DATA('0037FTA',     '03',     '124',     '08',     '171.06',     '€/ud'),
			T_TIPO_DATA('0038FTA',     '03',     '124',     '08',     '207.00',     '€/ud'),
			T_TIPO_DATA('0039FTA',     '03',     '124',     '08',     '293.25',     '€/ud'),
			T_TIPO_DATA('0040FTA',     '03',     '124',     '08',     '35.51',     '€/ud'),
			T_TIPO_DATA('0041FTA',     '03',     '124',     '08',     '211.98',     '€/ud'),
			T_TIPO_DATA('0042FTA',     '03',     '124',     '08',     '9.81',     '€/ud'),
			T_TIPO_DATA('0043FTA',     '03',     '124',     '08',     '98.09',     '€/ud'),
			T_TIPO_DATA('0044FTA',     '03',     '124',     '08',     '98.09',     '€/ud'),
			T_TIPO_DATA('0045FTA',     '03',     '124',     '08',     '195.35',     '€/ud'),
			T_TIPO_DATA('0046FTA',     '03',     '124',     '08',     '34.09',     '€/ud'),
			T_TIPO_DATA('0047FTA',     '03',     '124',     '08',     '50.64',     '€/ud'),
			T_TIPO_DATA('0048FTA',     '03',     '124',     '08',     '165.92',     '€/ud'),
			T_TIPO_DATA('0049FTA',     '03',     '124',     '08',     '198.00',     '€/ud'),
			T_TIPO_DATA('0050FTA',     '03',     '124',     '08',     '102.25',     '€/ud'),
			T_TIPO_DATA('0051FTA',     '03',     '124',     '08',     '145.63',     '€/ud'),
			T_TIPO_DATA('0052FTA',     '03',     '124',     '08',     '128.10',     '€/ud'),
			T_TIPO_DATA('0053FTA',     '03',     '124',     '08',     '151.78',     '€/ud'),
			T_TIPO_DATA('0054FTA',     '03',     '124',     '08',     '87.25',     '€/ud'),
			T_TIPO_DATA('0055FTA',     '03',     '124',     '08',     '71.83',     '€/ud'),
			T_TIPO_DATA('0056FTA',     '03',     '124',     '08',     '49.29',     '€/ud'),
			T_TIPO_DATA('0057FTA',     '03',     '124',     '08',     '68.13',     '€/ud'),
			T_TIPO_DATA('0058FTA',     '03',     '124',     '08',     '72.99',     '€/ud'),
			T_TIPO_DATA('0059FTA',     '03',     '124',     '08',     '55.57',     '€/ud'),
			T_TIPO_DATA('0060FTA',     '03',     '124',     '08',     '95.57',     '€/ud'),
			T_TIPO_DATA('0061FTA',     '03',     '124',     '08',     '23.25',     '€/ud'),
			T_TIPO_DATA('0062FTA',     '03',     '124',     '08',     '46.51',     '€/ud'),
			T_TIPO_DATA('0063FTA',     '03',     '124',     '08',     '438.13',     '€/ud'),
			T_TIPO_DATA('0064FTA',     '03',     '124',     '08',     '332.00',     '€/ud'),
			T_TIPO_DATA('0065FTA',     '03',     '124',     '08',     '37.00',     '€/ud'),
			T_TIPO_DATA('0066FTA',     '03',     '124',     '08',     '36.66',     '€/ud'),
			T_TIPO_DATA('0067FTA',     '03',     '124',     '08',     '25.00',     '€/ud'),
			T_TIPO_DATA('0068FTA',     '03',     '124',     '08',     '49.34',     '€/ud'),
			T_TIPO_DATA('0069FTA',     '03',     '124',     '08',     '87.35',     '€/ud'),
			T_TIPO_DATA('0070FTA',     '03',     '124',     '08',     '87.35',     '€/ud'),
			T_TIPO_DATA('0001CCN',     '03',     '124',     '08',     '26.13',     '€/h'),
			T_TIPO_DATA('0002CCN',     '03',     '124',     '08',     '26.13',     '€/h'),
			T_TIPO_DATA('0003CCN',     '03',     '124',     '08',     '363.75',     '€/ud'),
			T_TIPO_DATA('0004CCN',     '03',     '124',     '08',     '220.75',     '€/ud'),
			T_TIPO_DATA('0005CCN',     '03',     '124',     '08',     '264.72',     '€/ud'),
			T_TIPO_DATA('0006CCN',     '03',     '124',     '08',     '300.63',     '€/ud'),
			T_TIPO_DATA('0007CCN',     '03',     '124',     '08',     '102.31',     '€/ud'),
			T_TIPO_DATA('0008CCN',     '03',     '124',     '08',     '95.63',     '€/ud'),
			T_TIPO_DATA('0009CCN',     '03',     '124',     '08',     '81.35',     '€/ud'),
			T_TIPO_DATA('0010CCN',     '03',     '124',     '08',     '480.70',     '€/ud'),
			T_TIPO_DATA('0011CCN',     '03',     '124',     '08',     '237.00',     '€/ud'),
			T_TIPO_DATA('0012CCN',     '03',     '124',     '08',     '145.63',     '€/ud'),
			T_TIPO_DATA('0013CCN',     '03',     '124',     '08',     '86.88',     '€/ud'),
			T_TIPO_DATA('0014CCN',     '03',     '124',     '08',     '76.63',     '€/ud'),
			T_TIPO_DATA('0015CCN',     '03',     '124',     '08',     '1427.11',     '€/ud'),
			T_TIPO_DATA('0016CCN',     '03',     '124',     '08',     '119.50',     '€/ud'),
			T_TIPO_DATA('0017CCN',     '03',     '124',     '08',     '132.88',     '€/ud'),
			T_TIPO_DATA('0018CCN',     '03',     '124',     '08',     '53.25',     '€/ud'),
			T_TIPO_DATA('0001ELD',     '03',     '126',     '08',     '7.00',     '€/ud'),
			T_TIPO_DATA('0002ELD',     '03',     '126',     '08',     '4.89',     '€/ud'),
			T_TIPO_DATA('0003ELD',     '03',     '126',     '08',     '6.11',     '€/ud'),
			T_TIPO_DATA('0004ELD',     '03',     '126',     '08',     '25.56',     '€/ud'),
			T_TIPO_DATA('0005ELD',     '03',     '126',     '08',     '37.35',     '€/ud'),
			T_TIPO_DATA('0006ELD',     '03',     '126',     '08',     '35.12',     '€/ud'),
			T_TIPO_DATA('0007ELD',     '03',     '126',     '08',     '44.41',     '€/ud'),
			T_TIPO_DATA('0008ELD',     '03',     '126',     '08',     '59.13',     '€/ud'),
			T_TIPO_DATA('0009ELD',     '03',     '126',     '08',     '74.17',     '€/ud'),
			T_TIPO_DATA('0010ELD',     '03',     '126',     '08',     '69.33',     '€/ud'),
			T_TIPO_DATA('0011ELD',     '03',     '126',     '08',     '61.60',     '€/ud'),
			T_TIPO_DATA('0012ELD',     '03',     '126',     '08',     '70.76',     '€/ud'),
			T_TIPO_DATA('0013ELD',     '03',     '126',     '08',     '88.35',     '€/ud'),
			T_TIPO_DATA('0014ELD',     '03',     '126',     '08',     '27.63',     '€/ud'),
			T_TIPO_DATA('0015ELD',     '03',     '126',     '08',     '21.10',     '€/ud'),
			T_TIPO_DATA('0016ELD',     '03',     '126',     '08',     '28.50',     '€/ud'),
			T_TIPO_DATA('0017ELD',     '03',     '126',     '08',     '33.10',     '€/ud'),
			T_TIPO_DATA('0018ELD',     '03',     '126',     '08',     '38.21',     '€/ud'),
			T_TIPO_DATA('0019ELD',     '03',     '126',     '08',     '6.73',     '€/ud'),
			T_TIPO_DATA('0020ELD',     '03',     '126',     '08',     '8.14',     '€/ud'),
			T_TIPO_DATA('0021ELD',     '03',     '126',     '08',     '11.88',     '€/ud'),
			T_TIPO_DATA('0022ELD',     '03',     '126',     '08',     '9.83',     '€/ud'),
			T_TIPO_DATA('0023ELD',     '03',     '126',     '08',     '11.53',     '€/ud'),
			T_TIPO_DATA('0024ELD',     '03',     '126',     '08',     '25.97',     '€/ud'),
			T_TIPO_DATA('0025ELD',     '03',     '126',     '08',     '78.64',     '€/ud'),
			T_TIPO_DATA('0026ELD',     '03',     '126',     '08',     '287.00',     '€/ud'),
			T_TIPO_DATA('0027ELD',     '03',     '126',     '08',     '240.00',     '€/ud'),
			T_TIPO_DATA('0028ELD',     '03',     '126',     '08',     '252.00',     '€/ud'),
			T_TIPO_DATA('0029ELD',     '03',     '126',     '08',     '45.75',     '€/ud'),
			T_TIPO_DATA('0030ELD',     '03',     '126',     '08',     '61.59',     '€/ud'),
			T_TIPO_DATA('0031ELD',     '03',     '126',     '08',     '156.19',     '€/ud'),
			T_TIPO_DATA('0032ELD',     '03',     '126',     '08',     '270.63',     '€/ud'),
			T_TIPO_DATA('0033ELD',     '03',     '126',     '08',     '26.13',     '€/h'),
			T_TIPO_DATA('0034ELD',     '03',     '126',     '08',     '257.00',     '€/ud'),
			T_TIPO_DATA('0035ELD',     '03',     '126',     '08',     '245.63',     '€/ud'),
			T_TIPO_DATA('0036ELD',     '03',     '126',     '08',     '245.63',     '€/ud'),
			T_TIPO_DATA('0037ELD',     '03',     '126',     '08',     '36.23',     '€/ud'),
			T_TIPO_DATA('0038ELD',     '03',     '126',     '08',     '33.90',     '€/ud'),
			T_TIPO_DATA('0001ABA',     '03',     '125',     '08',     '3.51',     '€/m2'),
			T_TIPO_DATA('0002ABA',     '03',     '125',     '08',     '9.51',     '€/m2'),
			T_TIPO_DATA('0003ABA',     '03',     '125',     '08',     '11.30',     '€/m2'),
			T_TIPO_DATA('0004ABA',     '03',     '125',     '08',     '16.61',     '€/m2'),
			T_TIPO_DATA('0005ABA',     '03',     '125',     '08',     '3.61',     '€/m2'),
			T_TIPO_DATA('0006ABA',     '03',     '125',     '08',     '9.61',     '€/m2'),
			T_TIPO_DATA('0007ABA',     '03',     '125',     '08',     '6.61',     '€/ml'),
			T_TIPO_DATA('0008ABA',     '03',     '125',     '08',     '9.71',     '€/m2'),
			T_TIPO_DATA('0009ABA',     '03',     '125',     '08',     '6.20',     '€/m2'),
			T_TIPO_DATA('0010ABA',     '03',     '125',     '08',     '8.50',     '€/m2'),
			T_TIPO_DATA('0011ABA',     '03',     '125',     '08',     '7.91',     '€/m2'),
			T_TIPO_DATA('0012ABA',     '03',     '125',     '08',     '8.50',     '€/m2'),
			T_TIPO_DATA('0013ABA',     '03',     '125',     '08',     '4.11',     '€/m2'),
			T_TIPO_DATA('0014ABA',     '03',     '125',     '08',     '5.70',     '€/m2'),
			T_TIPO_DATA('0015ABA',     '03',     '125',     '08',     '5.60',     '€/m2'),
			T_TIPO_DATA('0016ABA',     '03',     '125',     '08',     '7.10',     '€/m2'),
			T_TIPO_DATA('0001CRA',     '03',     '127',     '08',     '25.91',     '€/ud'),
			T_TIPO_DATA('0002CRA',     '03',     '127',     '08',     '30.41',     '€/ud'),
			T_TIPO_DATA('0003CRA',     '03',     '127',     '08',     '34.20',     '€/ud'),
			T_TIPO_DATA('0001UBA',     '03',     '125',     '08',     '25.20',     '€/m2'),
			T_TIPO_DATA('0002UBA',     '03',     '125',     '08',     '24.55',     '€/m2'),
			T_TIPO_DATA('0003UBA',     '03',     '125',     '08',     '22.36',     '€/m2'),
			T_TIPO_DATA('0004UBA',     '03',     '125',     '08',     '300.00',     '€/m2'),
			T_TIPO_DATA('0005UBA',     '03',     '125',     '08',     '33.13',     '€/m2'),
			T_TIPO_DATA('0006UBA',     '03',     '125',     '08',     '30.38',     '€/m2'),
			T_TIPO_DATA('0001PCI',     '03',     '37',     '08',     '12.10',     '€/ud'),
			T_TIPO_DATA('0002PCI',     '03',     '37',     '08',     '96.00',     '€/ud'),
			T_TIPO_DATA('0003PCI',     '03',     '37',     '08',     '8.89',     '€/ud'),
			T_TIPO_DATA('0004PCI',     '03',     '37',     '08',     '60.75',     '€/ud'),
			T_TIPO_DATA('0005PCI',     '03',     '37',     '08',     '483.13',     '€/ud'),
			T_TIPO_DATA('0006PCI',     '03',     '37',     '08',     '338.25',     '€/ud'),
			T_TIPO_DATA('0007PCI',     '03',     '37',     '08',     '206.88',     '€/ud'),
			T_TIPO_DATA('0008PCI',     '03',     '37',     '08',     '181.88',     '€/ud'),
			T_TIPO_DATA('0009PCI',     '03',     '37',     '08',     '432.00',     '€/ud'),
			T_TIPO_DATA('0010PCI',     '03',     '37',     '08',     '438.15',     '€/ud'),
			T_TIPO_DATA('0011PCI',     '03',     '37',     '08',     '84.73',     '€/ud'),
			T_TIPO_DATA('0001SGD',     '03',     '40',     '08',     '95.00',     '€/ud'),
			T_TIPO_DATA('0002SGD',     '03',     '40',     '08',     '650.00',     '€/ud'),
			T_TIPO_DATA('0003SGD',     '03',     '26',     '08',     '59.00',     '€/ud'),
			T_TIPO_DATA('0004SGD',     '03',     '26',     '08',     '22.80',     '€/ud'),
			T_TIPO_DATA('0001TSU',     '03',     '36',     '08',     '31.10',     '€/h'),
			T_TIPO_DATA('0002TSU',     '03',     '36',     '08',     '31.10',     '€/h'),
			T_TIPO_DATA('0003TSU',     '03',     '37',     '08',     '24.61',     '€/h'),
			T_TIPO_DATA('0004TSU',     '03',     '37',     '08',     '22.31',     '€/h'),
			T_TIPO_DATA('0005TSU',     '03',     '37',     '08',     '19.70',     '€/h'),
			T_TIPO_DATA('0006TSU',     '03',     '37',     '08',     '19.70',     '€/h'),
			T_TIPO_DATA('0007TSU',     '03',     '37',     '08',     '0.20',     '%'),
			T_TIPO_DATA('0008TSU',     '03',     '37',     '08',     '0.30',     '%'),
			T_TIPO_DATA('0001MC',     '03',     '106',     '08',     '28.91',     '€/ud'),
			T_TIPO_DATA('0002MC',     '03',     '106',     '08',     '186.20',     '€/ud'),
			T_TIPO_DATA('0003MC',     '03',     '106',     '08',     '58.80',     '€/ud'),
			T_TIPO_DATA('0004MC',     '03',     '106',     '08',     '119.81',     '€/ud'),
			T_TIPO_DATA('0005MC',     '03',     '106',     '08',     '105.00',     '€/ud'),
			T_TIPO_DATA('0006MC',     '03',     '106',     '08',     '146.71',     '€/ud'),
			T_TIPO_DATA('0007MC',     '03',     '106',     '08',     '118.51',     '€/ud'),
			T_TIPO_DATA('0008MC',     '03',     '106',     '08',     '97.20',     '€/ud'),
			T_TIPO_DATA('0009MC',     '03',     '106',     '08',     '119.20',     '€/ud'),
			T_TIPO_DATA('0010MC',     '03',     '106',     '08',     '105.91',     '€/ud'),
			T_TIPO_DATA('0011MC',     '03',     '106',     '08',     '94.91',     '€/ud'),
			T_TIPO_DATA('0012MC',     '03',     '106',     '08',     '130.91',     '€/ud'),
			T_TIPO_DATA('0013MC',     '03',     '106',     '08',     '138.01',     '€/ud'),
			T_TIPO_DATA('0014MC',     '03',     '106',     '08',     '119.00',     '€/ud'),
			T_TIPO_DATA('0015MC',     '03',     '106',     '08',     '164.00',     '€/ud'),
			T_TIPO_DATA('0001E',     '03',     '107',     '08',     '152.41',     '€/ud'),
			T_TIPO_DATA('0002E',     '03',     '107',     '08',     '195.61',     '€/ud'),
			T_TIPO_DATA('0003E',     '03',     '107',     '08',     '217.10',     '€/ud'),
			T_TIPO_DATA('0004E',     '03',     '107',     '08',     '186.80',     '€/ud'),
			T_TIPO_DATA('0005E',     '03',     '107',     '08',     '81.70',     '€/ud'),
			T_TIPO_DATA('0006E',     '03',     '107',     '08',     '98.71',     '€/ud'),
			T_TIPO_DATA('0007E',     '03',     '107',     '08',     '240.00',     '€/ud'),
			T_TIPO_DATA('0008E',     '03',     '107',     '08',     '287.71',     '€/ud'),
			T_TIPO_DATA('0009E',     '03',     '107',     '08',     '304.30',     '€/ud'),
			T_TIPO_DATA('0010E',     '03',     '107',     '08',     '714.10',     '€/ud'),
			T_TIPO_DATA('0011E',     '03',     '107',     '08',     '884.90',     '€/ud'),
			T_TIPO_DATA('0012E',     '03',     '107',     '08',     '1032.71',     '€/ud'),
			T_TIPO_DATA('0013E',     '03',     '107',     '08',     '179.20',     '€/ud'),
			T_TIPO_DATA('0014E',     '03',     '107',     '08',     '234.81',     '€/ud'),
			T_TIPO_DATA('0001PE',    '03',      '57',     '08',     '385.00',     '€/ud') 		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS < 1 THEN

			-- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(CFT_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;

			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                      ''||TRIM(V_TMP_TIPO_DATA(5))||', '''||TRIM(V_TMP_TIPO_DATA(6))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
 			V_COUNT_INSERT := V_COUNT_INSERT + 1;

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_INSERT||' registros en la tabla ACT_CFT_CONFIG_TARIFA');
	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT
