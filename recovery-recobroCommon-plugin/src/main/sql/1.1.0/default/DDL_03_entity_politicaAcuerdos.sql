-- añadir a la tabla de politica de acuerdo-palancas dos columnas nuevas para indicar los tiempos de inmunidad por tipo de palanca

ALTER TABLE RCF_PAA_POL_ACUERDOS_PALANCAS ADD (RCF_PAA_TIEMPO_INUMIDAD1 NUMBER(5));

ALTER TABLE RCF_PAA_POL_ACUERDOS_PALANCAS ADD (RCF_PAA_TIEMPO_INMUNIDAD1 NUMBER(5));