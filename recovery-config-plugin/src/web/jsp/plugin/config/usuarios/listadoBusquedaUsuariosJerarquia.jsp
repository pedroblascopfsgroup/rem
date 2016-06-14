<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


	
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;

	 var comboJerarquia = app.creaCombo({data:jerarquia, 
    									triggerAction: 'all', 
    									value:jerarquia.diccionario[0].id, 
    									name : 'jerarquia', 
    									fieldLabel : '<s:message code="plugin.config.usuarios.busqueda.control.tab.jerarquia" text="**Jerarquia" />'
    									<app:test id="idComboJerarquia" addComa="true"/>	
    								});
	var listadoCodigoZonas = [];
	
	comboJerarquia.on('select',function(){
		if(comboJerarquia.value != '') {
			comboZonas.setDisabled(false);
			optionsZonasStore.setBaseParam('idJerarquia', comboJerarquia.getValue());
			
		}else{
			comboZonas.setDisabled(true);
		}
	});
	
	var codZonaSel='';
	var desZonaSel='';
	
	var zonasRecord = Ext.data.Record.create([
		,{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	//Template para el combo de zonas
    var zonasTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{descripcion}&nbsp;&nbsp;&nbsp;</p><p>{codigo}</p>',
        '</div></tpl>'
    );
    
    
    var optionsZonasStore = page.getStore({
	       flow: 'admusuario/getZonasInstant'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
    
    //Combo de zonas
    var comboZonas = new Ext.form.ComboBox({
        name: 'comboZonas'
        ,disabled:true 
        ,allowBlank:true
        ,store:optionsZonasStore
        ,width:220
        ,fieldLabel: '<s:message code="plugin.config.usuarios.busqueda.control.tab.jerarquia.centros" text="**Centros"/>'
        ,tpl: zonasTemplate  
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
        	codZonaSel=record.data.codigo;
        	desZonaSel=record.data.descripcion;
         }
    });	
    
    var recordZona = Ext.data.Record.create([
		{name: 'codigoZona'},
		{name: 'descripcionZona'}
	]);
    
    
   	var zonasStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordZona)
	});
    
    
    var zonasCM = new Ext.grid.ColumnModel([
		 {header : '<s:message code="plugin.config.usuarios.busqueda.control.tab.jerarquia.codigo" text="**Código" />', dataIndex : 'codigoZona' ,sortable:false, hidden:false, width:80}
		,{header : '<s:message code="plugin.config.usuarios.busqueda.control.tab.jerarquia.nombre" text="**Nombre" />', dataIndex : 'descripcionZona',sortable:false, hidden:false, width:200}
	]);
	
	var zonasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="plugin.config.usuarios.busqueda.control.tab.jerarquia.centros" text="**Centros" />'
	    ,cm: zonasCM
	    ,store: zonasStore
	    ,width: 300
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});

	var incluirZona = function() {
	    var zonaAInsertar = zonasGrid.getStore().recordType;
   		var p = new zonaAInsertar({
   			codigoZona: codZonaSel,
   			descripcionZona: desZonaSel
   		});
		zonasStore.insert(0, p);
		listadoCodigoZonas.push(codZonaSel);
	}

	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,minWidth:60
		,handler : function(){
			incluirZona();
			codZonaSel='';
   			desZonaSel='';
   			btnIncluir.setDisabled(true);
			comboZonas.focus();
		}
	});

	var zonaAExcluir = -1;
	var codZonaExcluir = '';
	
	zonasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codZonaExcluir = grid.selModel.selections.get(0).data.codigoZona;
   		zonaAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});

	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,minWidth:60
		,handler : function(){
			if (zonaAExcluir >= 0) {
				zonasStore.removeAt(zonaAExcluir);
				listadoCodigoZonas.remove(codZonaExcluir);
			}
			zonaAExcluir = -1;
	   		btnExcluir.setDisabled(true);
		}
	});
	
	var filtrosTabJerarquia = new Ext.Panel({
		title:'<s:message code="plugin.config.usuarios.busqueda.control.tab.jerarquia" text="**Jerarquia" />'
		,autoHeight:true
		,bodyStyle:'padding: 0px'
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboJerarquia,comboZonas]
				},{
					layout:'form'
					,items: [btnIncluir,btnExcluir]
				},{
					layout:'form'
					,items: [zonasGrid]
				}]
	});
    


