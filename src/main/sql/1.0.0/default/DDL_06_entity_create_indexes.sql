set serveroutput on;
declare
					nCount NUMBER;
					type t_indices is record (
            idx_name varchar2(30 char)
            , idx_table varchar2(30 char)
            , idx_column varchar2(100 char)
          );
          type idx_indices is table of t_indices index by binary_integer;
          idx idx_indices;
begin
					idx(1).idx_name := 'IDX_ARP_PER_ID';
          idx(1).idx_table := 'ARP_ARQ_RECOBRO_PERSONA';
          idx(1).idx_column := 'PER_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_ARP_ARQ_DATE';
          idx(idx.last).idx_table := 'ARP_ARQ_RECOBRO_PERSONA';
          idx(idx.last).idx_column := 'ARQ_DATE';
          
          idx(idx.last + 1).idx_name := 'IDX_CNT_LIBRES_ARQ_REC_EXT_P';
          idx(idx.last).idx_table := 'TMP_REC_CNT_LIBRES_ARQ_REC_EXT';
          idx(idx.last).idx_column := 'PER_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_CNT_LIBRES_ARQ_REC_EXT_C';
          idx(idx.last).idx_table := 'TMP_REC_CNT_LIBRES_ARQ_REC_EXT';
          idx(idx.last).idx_column := 'CNT_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_DRE_PER_ID';
          idx(idx.last).idx_table := 'DATA_RULE_ENGINE';
          idx(idx.last).idx_column := 'PER_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_BATCH_DATOS_SALIDA_1';
          idx(idx.last).idx_table := 'BATCH_DATOS_SALIDA';
          idx(idx.last).idx_column := 'EXP_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_BATCH_DATOS_SALIDA_2';
          idx(idx.last).idx_table := 'BATCH_DATOS_SALIDA';
          idx(idx.last).idx_column := 'CNT_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_BATCH_DATOS_SALIDA_3';
          idx(idx.last).idx_table := 'BATCH_DATOS_SALIDA';
          idx(idx.last).idx_column := 'PER_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_CNT_BORRADO';
          idx(idx.last).idx_table := 'CNT_CONTRATOS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_PER_BORRADO';
          idx(idx.last).idx_table := 'PER_PERSONAS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_CPE_BORRADO';
          idx(idx.last).idx_table := 'CPE_CONTRATOS_PERSONAS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_EXP_BORRADO';
          idx(idx.last).idx_table := 'EXP_EXPEDIENTES';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_EXP_EXP_ID';
          idx(idx.last).idx_table := 'EXP_EXPEDIENTES';
          idx(idx.last).idx_column := 'EXP_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_EXR_EXP_REC_ID';
          idx(idx.last).idx_table := 'EXR_EXPEDIENTE_RECOBRO';
          idx(idx.last).idx_column := 'EXP_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_EXP_MANUAL';
          idx(idx.last).idx_table := 'EXP_EXPEDIENTES';
          idx(idx.last).idx_column := 'EXP_MANUAL';
          
          idx(idx.last + 1).idx_name := 'IDX_CEX_BORRADO';
          idx(idx.last).idx_table := 'CEX_CONTRATOS_EXPEDIENTE';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_PEX_BORRADO';
          idx(idx.last).idx_table := 'PEX_PERSONAS_EXPEDIENTE';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_CRE_BORRADO';
          idx(idx.last).idx_table := 'CRE_CICLO_RECOBRO_EXP';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_CRE_EXP_ID';
          idx(idx.last).idx_table := 'CRE_CICLO_RECOBRO_EXP';
          idx(idx.last).idx_column := 'EXP_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_CRE_FECHA_BAJA';
          idx(idx.last).idx_table := 'CRE_CICLO_RECOBRO_EXP';
          idx(idx.last).idx_column := 'CRE_FECHA_BAJA';
          
          idx(idx.last + 1).idx_name := 'IDX_CRC_BORRADO';
          idx(idx.last).idx_table := 'CRC_CICLO_RECOBRO_CNT';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_CRC_CRE_ID';
          idx(idx.last).idx_table := 'CRC_CICLO_RECOBRO_CNT';
          idx(idx.last).idx_column := 'CRE_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_CRC_FECHA_BAJA';
          idx(idx.last).idx_table := 'CRC_CICLO_RECOBRO_CNT';
          idx(idx.last).idx_column := 'CRC_FECHA_BAJA';
          
          idx(idx.last + 1).idx_name := 'IDX_CRP_BORRADO';
          idx(idx.last).idx_table := 'CRP_CICLO_RECOBRO_PER';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_CRP_CRE_ID';
          idx(idx.last).idx_table := 'CRP_CICLO_RECOBRO_PER';
          idx(idx.last).idx_column := 'CRE_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_CRP_FECHA_BAJA';
          idx(idx.last).idx_table := 'CRP_CICLO_RECOBRO_PER';
          idx(idx.last).idx_column := 'CRP_FECHA_BAJA';
          
          idx(idx.last + 1).idx_name := 'IDX_CNT_CNT_FECHA_EXTRACCION';
          idx(idx.last).idx_table := 'CNT_CONTRATOS';
          idx(idx.last).idx_column := 'CNT_FECHA_EXTRACCION';
          
          idx(idx.last + 1).idx_name := 'IDX_MOV_MOV_FECHA_EXTRACCION';
          idx(idx.last).idx_table := 'MOV_MOVIMIENTOS';
          idx(idx.last).idx_column := 'MOV_FECHA_EXTRACCION';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_ESC_BORRADO';
          idx(idx.last).idx_table := 'RCF_ESC_ESQUEMA_CARTERAS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_SCA_BORRADO';
          idx(idx.last).idx_table := 'RCF_SCA_SUBCARTERA';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_SUA_BORRADO';
          idx(idx.last).idx_table := 'RCF_SUA_SUBCARTERA_AGENCIAS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_TGC_BORRADO';
          idx(idx.last).idx_table := 'RCF_DD_TGC_TIPO_GESTION_CART';
          idx(idx.last).idx_column := 'BORRADO';
          
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_TPR_BORRADO';
          idx(idx.last).idx_table := 'RCF_DD_TPR_TIPO_REPARTO_SUBC';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_ITV_BORRADO';
          idx(idx.last).idx_table := 'RCF_ITV_ITI_METAS_VOLANTES';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_MFA_BORRADO';
          idx(idx.last).idx_table := 'RCF_MFA_MODELOS_FACTURACION';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_AGE_BORRADO';
          idx(idx.last).idx_table := 'RCF_AGE_AGENCIAS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_POA_BORRADO';
          idx(idx.last).idx_table := 'RCF_POA_POLITICA_ACUERDOS';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_MOR_BORRADO';
          idx(idx.last).idx_table := 'RCF_MOR_MODELO_RANKING';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_AER_BORRADO';
          idx(idx.last).idx_table := 'RCF_DD_AER_AMBITO_EXP_REC';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_TCE_BORRADO';
          idx(idx.last).idx_table := 'RCF_DD_TCE_TIPO_CARTERA_ESQ';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_MTR_BORRADO';
          idx(idx.last).idx_table := 'RCF_DD_MTR_MODELO_TRANSICION';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_ESQ_BORRADO';
          idx(idx.last).idx_table := 'RCF_ESQ_ESQUEMA';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_CAR_BORRADO';
          idx(idx.last).idx_table := 'RCF_CAR_CARTERA';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RULE_DEFINITION_BORRADO';
          idx(idx.last).idx_table := 'RULE_DEFINITION';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_PER_GCL_1';
          idx(idx.last).idx_table := 'PER_GCL';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_PER_GCL_2';
          idx(idx.last).idx_table := 'PER_GCL';
          idx(idx.last).idx_column := 'PER_ID';
          
          for i in idx.FIRST .. idx.last loop
            DBMS_OUTPUT.PUT_LINE('Intentando crear el índice: '||idx(i).idx_name);
            
            SELECT COUNT(1) INTO NCOUNT FROM USER_IND_COLUMNS WHERE TABLE_NAME = idx(i).idx_table AND COLUMN_NAME = idx(i).idx_column;
            if (ncount = 0) then
              EXECUTE IMMEDIATE 'create index '||idx(i).idx_name||' on '||idx(i).idx_table||'('||idx(i).idx_column||')';
              DBMS_OUTPUT.PUT_LINE('Índice creado '||idx(i).idx_name);
            end if;
          end loop;
END;
/
