CREATE OR REPLACE FUNCTION obtenerTablaPersonasAfectadas(p_prc_id IN NUMBER) RETURN VARCHAR2 IS
  
  resultado VARCHAR2(4000);
  
  CURSOR c_personas(p_proc_id NUMBER) IS
    select PER.PER_DOC_ID "PER_DOC_ID", PER.PER_APELLIDO1 "PER_APELLIDO1", PER.PER_APELLIDO2 "PER_APELLIDO2", PER.PER_NOMBRE "PER_NOMBRE"
    from prc_per ppe
    inner join per_personas per on ppe.PER_ID=per.PER_ID
    where per.BORRADO=0 and
    ppe.PRC_ID=p_proc_id
  ;
  r_personas c_personas%ROWTYPE;

--  CURSOR c_direcciones(p_per_id NUMBER) IS
--    SELECT DIR.DIR_DOMICILIO "DIR_DOMICILIO", DIR.DIR_CODIGO_POSTAL "DIR_CODIGO_POSTAL", 
--    DIR.DIR_MUNICIPIO "DIR_MUNICIPIO", PRV.DD_PRV_DESCRIPCION "DIR_PROVINCIA" 
--    FROM DIR_DIRECCIONES DIR
--    LEFT JOIN LINMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID=DIR.DD_PRV_ID
--    WHERE DIR.DIR_ID=p_per_id;
--  r_direcciones c_direcciones%ROWTYPE;
  
BEGIN

   resultado := '';
   
   OPEN c_personas(p_prc_id);
   LOOP
      FETCH c_personas INTO r_personas;
      EXIT WHEN c_personas%NOTFOUND;
      resultado := resultado || r_personas.PER_DOC_ID || ' - ' || r_personas.PER_APELLIDO1 || ' ' || r_personas.PER_APELLIDO2 || ', ' || r_personas.PER_NOMBRE || ' - ';
--      OPEN c_direcciones(r_personas.DIR_ID);
--      LOOP
--         FETCH c_direcciones INTO r_direcciones;
--        EXIT WHEN c_direcciones%NOTFOUND;
--         resultado := resultado || 'Domicilio: ' || r_direcciones.DIR_DOMICILIO || ' - CP: ' || r_direcciones.DIR_CODIGO_POSTAL 
--            || ' - Municipio: ' || r_direcciones.DIR_MUNICIPIO || ' - Provincia: ' || r_direcciones.DIR_PROVINCIA || ' *** ';
--         CLOSE c_direcciones;
--         EXIT;
--      END LOOP;
   END LOOP;
   CLOSE c_personas;
   
   RETURN resultado;
END;
