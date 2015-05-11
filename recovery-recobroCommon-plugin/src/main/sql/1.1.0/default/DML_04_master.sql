-- modificar la descripción del estado del acuerdo de cerrado a cancelado
update DD_EAC_ESTADO_ACUERDO set DD_EAC_DESCRIPCION ='Cancelado' where DD_EAC_DESCRIPCION='Cerrado';

update DD_EAC_ESTADO_ACUERDO set DD_EAC_DESCRIPCION_LARGA ='Cancelado' where DD_EAC_DESCRIPCION_LARGA='Cerrado';

commit;