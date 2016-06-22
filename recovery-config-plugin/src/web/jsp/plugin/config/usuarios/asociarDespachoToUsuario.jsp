<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>
	
	var codDespachoSel='';
	var desDespachoSel='';
	var usernameSel='';
	
	var despachosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'despacho'}
	]);
	
	//Template para el combo de zonas
    var despachosTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{despacho}</p>',
        '</div></tpl>'
    );
    
    var listadocodigoDespachos = [];
    
    var optionsDespachosStore = page.getStore({
	       flow: 'admdespachoexterno/getDespachosInstant'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listaDespachos'
	    }, despachosRecord)
	       
	});
	
	optionsDespachosStore.setBaseParam('idUsuario', ${usuario.id});
   
    //Combo de zonas
    var comboDespachos = new Ext.form.ComboBox({
        name: 'comboDespachos'
        ,disabled:false
        ,allowBlank:true
        ,store:optionsDespachosStore
        ,width:220
        ,fieldLabel: '<s:message code="plugin.config.despachoExterno.consultadespacho.cabecera.title" text="**despachos"/>'
        ,tpl: despachosTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 2 
        ,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) {
        	btnIncluir.setDisabled(false);
        	codDespachoSel=record.data.id;
        	desDespachoSel=record.data.despacho 
        	//usernameSel=record.data.username;    	
         }
    });	
    
    var recordDespacho = Ext.data.Record.create([
		{name: 'id'},
		{name: 'nombre'}
		//{name: 'descripcionDespacho'},
		//{name: 'username'}
	]);
    
    
   	var despachosStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordDespacho)
	});
    
    
    var despachosCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.config.despachoExterno.guardarGestor.grid.columna.idUser" text="**Id" />', dataIndex : 'codigoDespacho' ,sortable:false, hidden:true, width:80}
		,{header : '<s:message code="plugin.config.despachoExterno.consultadespacho.cabecera.title" text="**Despacho" />', dataIndex : 'descripcionDespacho' ,sortable:false, hidden:false, width:250}
		//,{header : '<s:message code="plugin.config.despachoExterno.guardarGestor.grid.columna.nombre" text="**Nombre" />', dataIndex : 'descripcionDespacho',sortable:false, hidden:false, width:200}
	]);
	
	var zonasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="plugin.config.despachoExterno.grid.listadespachos" text="**despachos" />'
	    ,cm: despachosCM
	    ,store: despachosStore
	    ,width: 300
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});

	var incluirDespacho = function() {
	    var zonaAInsertar = zonasGrid.getStore().recordType;
   		var p = new zonaAInsertar({
   			codigoDespacho: codDespachoSel
   			,descripcionDespacho: desDespachoSel
   		//	,username: usernameSel
   		});
   		
   		var noEstaIncluido = true;	
   		for(var i=0; i< listadocodigoDespachos.length; i++) {
   			if(listadocodigoDespachos[i] == codDespachoSel) {
   				noEstaIncluido=false;
   			}
   		}		
   		if(noEstaIncluido) {
			despachosStore.insert(0, p);
			listadocodigoDespachos.push(codDespachoSel);
		}
	}

	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,minWidth:60
		,handler : function(){
			incluirDespacho();
			codDespachoSel='';
   			desDespachoSel='';
   			usernameSel='';
   			btnIncluir.setDisabled(true);
			comboDespachos.focus();
			btnGuardar.setDisabled(false);
		}
	});

	var despachoAExcluir = -1;
	var codDespachoExcluir = '';
	
	zonasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codDespachoExcluir = grid.selModel.selections.get(0).data.codigoDespacho;
   		despachoAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});

	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,minWidth:60
		,handler : function(){
			if (despachoAExcluir >= 0) {
				despachosStore.removeAt(despachoAExcluir);
				listadocodigoDespachos.remove(codDespachoExcluir);
			}
			despachoAExcluir = -1;
	   		btnExcluir.setDisabled(true);
	   		if(listadocodigoDespachos.length == 0) {
	   			btnGuardar.setDisabled(true);
	   		}
		}
	});
	
	var listadoDespachosId = new Ext.form.Field({name:'listadoDespachosId',value:''});
	
	<pfs:defineParameters name="parametros" paramId="${usuario.id}" 
		listadoDespachosId="listadoDespachosId"
	/>
	
	<pfs:editForm saveOrUpdateFlow="admdespachoexterno/guardaDespachoAsociados"
		leftColumFields="comboDespachos, btnIncluir, btnExcluir"
		rightColumFields="zonasGrid"
		parameters="parametros"  />
		
	btnGuardar.setDisabled(true);
	
	btnGuardar.on('click',function() {
		for(var i=0 ; i < listadocodigoDespachos.length ; i++) {
			if(i < listadocodigoDespachos.length-1)
				listadoDespachosId.setValue(listadoDespachosId.getValue() + listadocodigoDespachos[i] + ',');
			else
				listadoDespachosId.setValue(listadoDespachosId.getValue() + listadocodigoDespachos[i]);
		}
		
	});
	
			
</fwk:page>