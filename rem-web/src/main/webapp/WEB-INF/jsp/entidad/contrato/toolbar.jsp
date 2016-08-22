<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

function(entidad,page){

	var toolbar=new Ext.Toolbar();

	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			entidad.refrescar();
		}
	});
	
	toolbar.setValue = function(data){
		
		var visible = [];
		var condition = '';
		for (i=0; i < buttonsL_contrato.length; i++){
			if (buttonsL_contrato[i].condition!=null && buttonsL_contrato[i].condition!=''){
				condition = eval(buttonsL_contrato[i].condition);
				visible.push([buttonsL_contrato[i], condition]);
			}
		}
		for (i=0; i < buttonsR_contrato.length; i++){
			if (buttonsR_contrato[i].condition!=null && buttonsR_contrato[i].condition!=''){
				condition = eval(buttonsR_contrato[i].condition);
				visible.push([buttonsR_contrato[i], condition]);
			}
		}
		entidad.setVisible(visible);
	
	}
	toolbar.getValue = function(data){}
	
	toolbar.add(buttonsL_contrato);
	toolbar.add('->');
	toolbar.add(buttonsR_contrato);
	toolbar.add(botonRefrezcar);
	toolbar.add(app.crearBotonAyuda());
	return toolbar;
};
