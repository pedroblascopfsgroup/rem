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
	
	var codUsuarioSel='';
	var desUsuarioSel='';
	var usernameSel='';
	
	var usuariosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
		,{name:'apellido1'}
		,{name:'apellido2'}
		,{name:'username'}
	]);
	
	//Template para el combo de zonas
    var usuariosTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{nombre}&nbsp;{apellido1}&nbsp;{apellido2}&nbsp;</p><p>{username}</p>',
        '</div></tpl>'
    );
    
    
    <%-- --------------- 
   
	var dicListaGestores =
		<json:object name="dicListaGestores">
			<json:array name="gestores" items="${listaGestores}" var="ges">
					<json:object>
						<json:property name="id" value="${ges.id}" />
						<json:property name="nombre" value="${ges.nombre}" />
						<json:property name="apellido1" value="${ges.apellido1}" />
						<json:property name="apellido2" value="${ges.apellido2}" />
						<json:property name="username" value="${ges.username}" />
					</json:object>
			</json:array>
		</json:object>;
    
    var optionsUsuariosStore = new Ext.data.JsonStore({
	       fields: ['id', 'nombre', 'apellido1', 'apellido2', 'username']
	       ,data : dicListaGestores
	       ,root: 'gestores'
	});
    debugger;--%>
     <%-- ---------------  --%>
    
    var listadocodigoUsuarios = [];
    
    var optionsUsuariosStore = page.getStore({
	       flow: 'admdespachoexterno/getUsuariosInstant'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listaGestoresExternos'
	    }, usuariosRecord)
	       
	});
	
	optionsUsuariosStore.setBaseParam('idDespacho', ${idDespacho});
   
    //Combo de zonas
    var comboUsuarios = new Ext.form.ComboBox({
        name: 'comboUsuarios'
        ,disabled:false
        ,allowBlank:true
        ,store:optionsUsuariosStore
        ,width:220
        ,fieldLabel: '<s:message code="plugin.config.despachoExterno.guardarGestor.combo.title" text="**usuarios"/>'
        ,tpl: usuariosTemplate  
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
        	codUsuarioSel=record.data.id;
        	desUsuarioSel=record.data.nombre +' '+ record.data.apellido1 +' '+ record.data.apellido2; 
        	usernameSel=record.data.username;    	
         }
    });	
    
    var recordUsuario = Ext.data.Record.create([
		{name: 'id'},
		{name: 'codigoUsuario'},
		{name: 'descripcionUsuario'},
		{name: 'username'}
	]);
    
    
   	var usuariosStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordUsuario)
	});
    
    
    var usuariosCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.config.despachoExterno.guardarGestor.grid.columna.idUser" text="**Id" />', dataIndex : 'codigoUsuario' ,sortable:false, hidden:true, width:80}
		,{header : '<s:message code="plugin.config.despachoExterno.guardarGestor.grid.columna.username" text="**Usuario" />', dataIndex : 'username' ,sortable:false, hidden:false, width:120}
		,{header : '<s:message code="plugin.config.despachoExterno.guardarGestor.grid.columna.nombre" text="**Nombre" />', dataIndex : 'descripcionUsuario',sortable:false, hidden:false, width:200}
	]);
	
	var zonasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="plugin.config.despachoExterno.guardarGestor.combo.title" text="**usuarios" />'
	    ,cm: usuariosCM
	    ,store: usuariosStore
	    ,width: 300
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});

	var incluirUsuario = function() {
	    var zonaAInsertar = zonasGrid.getStore().recordType;
   		var p = new zonaAInsertar({
   			codigoUsuario: codUsuarioSel,
   			descripcionUsuario: desUsuarioSel,
   			username: usernameSel
   		});
		usuariosStore.insert(0, p);
		listadocodigoUsuarios.push(codUsuarioSel);
	}

	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,minWidth:60
		,handler : function(){
			incluirUsuario();
			codUsuarioSel='';
   			desUsuarioSel='';
   			usernameSel='';
   			btnIncluir.setDisabled(true);
			comboUsuarios.focus();
		}
	});

	var usuarioAExcluir = -1;
	var codUsuarioExcluir = '';
	
	zonasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codUsuarioExcluir = grid.selModel.selections.get(0).data.codigoUsuario;
   		usuarioAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});

	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,minWidth:60
		,handler : function(){
			if (usuarioAExcluir >= 0) {
				usuariosStore.removeAt(usuarioAExcluir);
				listadocodigoUsuarios.remove(codUsuarioExcluir);
			}
			usuarioAExcluir = -1;
	   		btnExcluir.setDisabled(true);
		}
	});
	
	var listadoUsuariosId = new Ext.form.Field({name:'listUsers',value:''});
	
	<pfs:defineParameters name="parametros" paramId="${idDespacho}" 
		listaUsuariosId="listadoUsuariosId"
	/>
	debugger;
	<pfs:editForm saveOrUpdateFlow="admdespachoexterno/guardarGestores"
		leftColumFields="comboUsuarios, btnIncluir, btnExcluir"
		rightColumFields="zonasGrid"
		parameters="parametros"  />
		
	
	btnGuardar.on('click',function() {
		for(var i=0 ; i < listadocodigoUsuarios.length ; i++) {
			if(i < listadocodigoUsuarios.length-1)
				listadoUsuariosId.setValue(listadoUsuariosId.getValue() + listadocodigoUsuarios[i] + ',');
			else
				listadoUsuariosId.setValue(listadoUsuariosId.getValue() + listadocodigoUsuarios[i]);
		}
	});
	
			
</fwk:page>