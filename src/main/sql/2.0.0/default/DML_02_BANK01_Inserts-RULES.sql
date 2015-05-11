DECLARE
    -- Querys
    query_body varchar (30048);
BEGIN
	
	query_body := 'UPDATE BANK01.RULE_DEFINITION 
	SET RD_DEFINITION = ''
		<rule title="Personas Excluidas Sociedad Cobro" type="or">                
			<rule title="PROMOTORES" type="or">                                
				<rule values="[24]" ruleid="2" operator="equal" title="Tipo Segmento PROMOTORES">Tipo Segmento PROMOTORES                                
				</rule>                                
				<rule values="[17]" ruleid="2" operator="equal" title="Tipo Segmento MICROPROMOTORES">Tipo Segmento MICROPROMOTORES                                
				</rule>                                
				<rule values="[27]" ruleid="2" operator="equal" title="Tipo Segmento PEQUENYOS Y MEDIANOS PROMOTORES">Tipo Segmento PEQUENYOS Y MEDIANOS PROMOTORES                                
				</rule>                    
			</rule>                
			<rule values="[0]" ruleid="66" operator="greaterThan" title="Riesgo Garantizado mayor que 0">Riesgo Garantizado mayor que 0                
			</rule>            
			<rule values="[10738]" ruleid="9" operator="equal" title="Oficina Gestora igual 10738">Oficina Gestora igual 10738        
			</rule>    
			<rule values="[51]" ruleid="153" operator="lessThan" title="Riesgo Directo Vencido de la persona menor que 51">Riesgo Directo Vencido  de la persona menor que 51
			</rule>
		</rule>''
	WHERE RD_ID = 301'; EXECUTE IMMEDIATE query_body;

	COMMIT;

END;
/