<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	<pfs:defineParameters name="arquetipoParams" paramId="${modelo.id}"/>
	
	var recargar = function (){
		app.openTab('${modelo.nombre}'
					,'/modelosArquetipos/ARQconsultarModelo'
					,{id:${modelo.id}}
					,{id:'ModeloRT${modelo.id}'}
				)
	};
	
	<pfs:hidden name="id" value="${modelo.id}" />

	<pfs:defineRecordType name="ArquetiposModeloRT">
		<pfs:defineTextColumn name="prioridad"/>
		<pfs:defineTextColumn name="arquetipo"/>
		<pfs:defineTextColumn name="itinerario"/>
		<pfs:defineTextColumn name="prioridad"/>
		<pfs:defineTextColumn name="nivel"/>
		<pfs:defineTextColumn name="gestion" />
		<pfs:defineTextColumn name="plazoDisparo" />  
		<pfs:defineTextColumn name="tipoSaltoNivel" /> 
	</pfs:defineRecordType>
	
	
	<pfs:remoteStore name="storeArquetipos" 
		dataFlow="plugin/arquetipos/modelosArquetipos/ARQlistaArquetiposModeloData"
		resultRootVar="arquetiposModelo" 
		recordType="ArquetiposModeloRT" 
		parameters="arquetipoParams"
		autoload="true"/>
		
	
	<%--
	<pfs:buttoncancel name="btnCancelar"/>
	
	 
	<pfs:button name="btnCerrar" caption="plugin.arquetipos.modelos.editarGrid.cerrar" captioneKey="**Cerrar">
		handler : function(){
			page.fireEvent(app.event.DONE);
		}
	</pfs:button>
	
	,
		listeners: {
			afteredit: function(e){
				var conn = new Ext.data.Connection();
				conn.request({
					url: page.resolveUrl('plugin/arquetipos/modelosArquetipos/ARQguardarDatosModArq'),
					params: {
						id: e.record.id,
						field: e.field,
						value: e.value
						}
					});
				
				}
			}	
	--%>
	
	var btnGuardar = new Ext.Button({
	text : '<s:message code="plugin.arquetipos.modelos.editarArquetioposModelo.guardar" text="**Guardar" />'
	,iconCls:'icon_ok'
	,handler : function(){
		Ext.Msg.confirm('<s:message code="plugin.arquetipos.modelos.editarArquetioposModelo.guardar" text="**Guardar" />','<s:message code="plugin.arquetipos.modelos.editarArquetipos.seguro" text="**¿Seguro que desea guardar?" />',this.decide,this);
		//this.guardar();
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
	,guardar : function(){
			page.webflow({
				flow : 'plugin/arquetipos/modelosArquetipos/ARQEditarGridArquetiposModelo' 
				,eventName : 'update'
				,success : function(){ page.fireEvent(app.event.DONE); }
				,params : grid.modifiedData
			});
		}
	});
	
	
	var btnCancelar = new Ext.Button({
	text : '<s:message code="plugin.arquetipos.modelos.editarArquetioposModelo.cancelar" text="**Cancelar" />'
	,iconCls:'icon_cancel'
	,handler : function(){
		Ext.Msg.confirm('<s:message code="plugin.arquetipos.modelos.editarArquetioposModelo.cancelar" text="**Cancelar" />','<s:message code="plugin.arquetipos.modelos.editarArquetioposModelo.seguro" text="**¿Seguro que desea descartar los cambios?" />',this.decide,this);
		//this.cancelar();
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.cancelar();
			}
		}
	,cancelar : function(){
			page.webflow({
				flow : 'plugin/arquetipos/modelosArquetipos/ARQEditarGridArquetiposModelo' 
				,eventName : 'fin1'
				,success : function(){ page.fireEvent(app.event.CANCEL); }
			});
		}
	});
	
	var nivel_edit = new Ext.form.TextField();
	var plazoDisparo_edit = new Ext.form.TextField();
	
	<pfsforms:ddCombo name="itinerario_edit" labelKey="" label="" value="" 
			dd="${itinerarios}" propertyCodigo="id" propertyDescripcion="nombre"/>	
			

	var itinerarios = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion'],
		data : itinerario_editDiccionario,
		root : 'diccionario'
	});

	var itinerario_nombre = function(val){
		var iti_finded = itinerarios.queryBy(function(rec){
			return rec.data.codigo == val;
		});
		
		if (iti_finded.getCount() > 0)
			return iti_finded.itemAt(0).data.descripcion;
		else
			return '';
	}
	
	
	Ext.util.CSS.createStyleSheet(".icon_arquetipo { background-image: url('../img/plugin/arquetipos/arquetipo.png');}");
	
	var grid = new Ext.grid.EditorGridPanel({
		title: '<s:message code="plugin.arquetipos.modelo.editar.titulo" text="**Arquetipos del modelo" />',
		stripeRows: true,
		resizable:true, 
		autoHeight: true,
		cls:'cursor_pointer',
		clickstoEdit: 1,
		store: storeArquetipos,
		iconCls:'icon_arquetipo',
		columns: [
			{header: '<s:message code="plugin.arquetipos.modelo.editar.prioridad" text="**Prioridad" />', dataIndex: 'prioridad'},
			{header: '<s:message code="plugin.arquetipos.modelo.editar.arquetipo" text="**Arquetipo" />', dataIndex: 'arquetipo'},
			{header: '<s:message code="plugin.arquetipos.modelo.editar.nivel" text="**Nivel" />', dataIndex:'nivel', editor: nivel_edit},
			{header: '<s:message code="plugin.arquetipos.modelo.editar.itinerario" text="**Itinerario" />', dataIndex: 'itinerario', renderer: itinerario_nombre, editor: itinerario_edit},
			{header: '<s:message code="plugin.arquetipos.modelo.editar.gestion" text="**Gestión" />', dataIndex: 'gestion'},	
			{header: '<s:message code="plugin.arquetipos.modelo.editar.plazoDisparo" text="**Plazo de disparo" />', dataIndex: 'plazoDisparo', editor: plazoDisparo_edit },	
			{header: '<s:message code="plugin.arquetipos.modelo.editar.tipoSalto" text="**Tipo de Salto" />', dataIndex: 'tipoSaltoNivel' }
		],
		bbar: [ btnGuardar,btnCancelar]
	});
		
	grid.modifiedData={};
	grid.on('afteredit', function(editEvent){
		grid.modifiedData['dtoArquetipos['+editEvent.row+'].'+editEvent.field]= editEvent.value;
	});
		
		page.add(grid);

</fwk:page>