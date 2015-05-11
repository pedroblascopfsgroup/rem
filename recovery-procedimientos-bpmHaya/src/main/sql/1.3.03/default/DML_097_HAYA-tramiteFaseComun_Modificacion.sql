

--HR-417
--No se puede derivar al t. fase común - El problema era el nombre de trámite en BBDD que era "tramiteFaseComunAbreviadoV4"
update dd_tpo_tipo_procedimiento set dd_tpo_xml_jbpm = 'haya_tramiteFaseComunAbreviadoV4' where dd_tpo_codigo = 'H009';

commit;