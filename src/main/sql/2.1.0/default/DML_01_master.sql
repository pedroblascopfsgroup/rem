INSERT INTO DD_EST_ESTADOS_ITINERARIOS
  (
    DD_EST_ID,
    DD_EIN_ID,
    DD_EST_ORDEN,
    DD_EST_CODIGO,
    DD_EST_DESCRIPCION,
    DD_EST_DESCRIPCION_LARGA,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  VALUES
  (
    S_DD_EST_EST_ITI.NEXTVAL,
    (SELECT DD_EIN_ID FROM DD_EIN_ENTIDAD_INFORMACION WHERE DD_EIN_CODIGO = '2'),
    1,
    'CMER',
    'Exp. recobro manual',
    'Creación manual expediente recobro',
    0,
    'DD',
    sysdate,
    0
  );
  
  COMMIT;