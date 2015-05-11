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
					idx(1).idx_name := 'IDX_EXC_BORRADO';
          idx(1).idx_table := 'EXC_EXCEPTUACION';
          idx(1).idx_column := 'BORRADO';
          
          idx(1).idx_name := 'IDX_EXC_FECHA_HASTA';
          idx(1).idx_table := 'EXC_EXCEPTUACION';
          idx(1).idx_column := 'EXC_FECHA_HASTA';
          
          idx(idx.last + 1).idx_name := 'IDX_DD_MOE_BORRADO';
          idx(idx.last).idx_table := 'DD_MOE_MOTIVO_EXCEPTUACION';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_DD_MOE_ID';
          idx(idx.last).idx_table := 'DD_MOE_MOTIVO_EXCEPTUACION';
          idx(idx.last).idx_column := 'DD_MOE_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_ECO_CNT_ID';
          idx(idx.last).idx_table := 'ECO_EXCEPTUACION_CONTRATO';
          idx(idx.last).idx_column := 'CNT_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_ECO_EXC_ID';
          idx(idx.last).idx_table := 'ECO_EXCEPTUACION_CONTRATO';
          idx(idx.last).idx_column := 'EXC_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_EPE_PER_ID';
          idx(idx.last).idx_table := 'EPE_EXCEPTUACION_PERSONA';
          idx(idx.last).idx_column := 'PER_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_EPE_EXC_ID';
          idx(idx.last).idx_table := 'EPE_EXCEPTUACION_PERSONA';
          idx(idx.last).idx_column := 'EXC_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_CRC_CNT_ID';
          idx(idx.last).idx_table := 'CRC_CICLO_RECOBRO_CNT';
          idx(idx.last).idx_column := 'CNT_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_GEE_BORRADO';
          idx(idx.last).idx_table := 'GEE_GESTOR_ENTIDAD';
          idx(idx.last).idx_column := 'BORRADO';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_TVI_ITV_ID';
          idx(idx.last).idx_table := 'RCF_ITV_ITI_METAS_VOLANTES';
          idx(idx.last).idx_column := 'RCF_ITV_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_RCF_SCA_ITV_ID';
          idx(idx.last).idx_table := 'RCF_SCA_SUBCARTERA';
          idx(idx.last).idx_column := 'RCF_ITV_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_DD_TIN_TITULAR';
          idx(idx.last).idx_table := 'DD_TIN_TIPO_INTERVENCION';
          idx(idx.last).idx_column := 'DD_TIN_TITULAR';
          
          idx(idx.last + 1).idx_name := 'IDX_DD_TIN_AVALISTA';
          idx(idx.last).idx_table := 'DD_TIN_TIPO_INTERVENCION';
          idx(idx.last).idx_column := 'DD_TIN_AVALISTA';
          
          idx(idx.last + 1).idx_name := 'IDX_DD_TIN_ID';
          idx(idx.last).idx_table := 'DD_TIN_TIPO_INTERVENCION';
          idx(idx.last).idx_column := 'DD_TIN_ID';
          
          
          idx(idx.last + 1).idx_name := 'IDX_GCL_GCL_ID';
          idx(idx.last).idx_table := 'GCL_GRUPOS_CLIENTES';
          idx(idx.last).idx_column := 'GCL_ID';
          
          idx(idx.last + 1).idx_name := 'IDX_ANT_ANT_ID';
          idx(idx.last).idx_table := 'ANT_ANTECEDENTES';
          idx(idx.last).idx_column := 'ANT_ID';
          
          
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
