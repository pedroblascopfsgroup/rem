<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>

	 var tipoCorrectorValor = '--';
	 <c:if test="${modeloFacturacion.tipoCorrector.descripcion != null}">
	  	tipoCorrectorValor = "${modeloFacturacion.tipoCorrector.descripcion}";
	 </c:if>
 
	<pfsforms:textfield name="tipoCorrector" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.tipoCorrector" 
		label="**Tipo de corrector" value="" readOnly="true" />
	
	tipoCorrector.setValue(tipoCorrectorValor);

	<c:if test="${modeloFacturacion.tipoCorrector.codigo == 'MEO'}">
		<pfsforms:textfield name="objetivoDeRecobro" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.objetivoDeRecobro" 
			label="**Objetivo de eficacia" value="${modeloFacturacion.objetivoRecobro}%" readOnly="true"  />
		objetivoDeRecobro.labelStyle = 'font-weight:bold; width:110px;'
	</c:if>
	
	var datos = new Ext.form.FieldSet({
		 style:'padding:0px'
		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,autoWidth:true
		,title:'<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.titulo" text="**Corrector Habilitado"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		,items :[{items:[tipoCorrector]} ,
				 {items : [<c:if test="${modeloFacturacion.tipoCorrector.codigo == 'MEO'}">objetivoDeRecobro</c:if>]} ]
	});
		
	var loadPanelModeloFact = function(title, flow, params){
		var contenido = Ext.getCmp("contFact_${idModFact}");
		contenido.removeAll();
		var url = '/${appProperties.appName}/'+flow+'.htm';
		contenido.setTitle(title);
		contenido.load({
		    url: url,
		    params: params, // or a URL encoded string
		    text: 'Cargando...',
		    timeout: 30,
		    scripts: true
		});
	};
	 
	var btnModificar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.fichaEsquema.modificar" text="**Modificar" />'
		,iconCls : 'icon_edit'
		,iconAlign: 'right'
		,handler : 	function() {
			var parms = {};
    		parms.idModFact='${idModFact}';
			var w = app.openWindow({
				flow: 'recobromodelofacturacion/editarTipoCorrector'
				,closable: true
				,width : 700
				,title :  '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.editarTipo" text="**Editar el tipo de corrector"/>'
				,params: parms
			});
			w.on(app.event.DONE, function(){
				loadPanelModeloFact('<s:message code="plugin.recobroConfig.modeloFacturacion.launcher.botones.correctores" text="**Correctores"/>', 
					"recobromodelofacturacion/abrirCorrectores",
					{idModFact: ${idModFact}});
				w.close();
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});	
		}
	});
	
	<pfs:defineRecordType name="tramoCorrector">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="posicion" />
			<pfs:defineTextColumn name="coeficiente" />
	</pfs:defineRecordType>
	
	<pfs:hidden name="idModFact" value="${idModFact}"/>
	<pfs:defineParameters name="params" paramId="" idModFact="idModFact"/>
	
	<pfs:remoteStore name="tramosCorrectoresDS" 
		dataFlow="recobromodelofacturacion/abrirListadoCorrectores"
		resultRootVar="correctores" 
		recordType="tramoCorrector" 
		parameters="params" 
		autoload="true"/>
	
	<pfs:defineColumnModel name="tramosCorrectoresCM">

		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.modeloFacturacion.corrector.cabeceraId" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		
		<pfs:defineHeader dataIndex="posicion"
			captionKey="plugin.recobroConfig.modeloFacturacion.corrector.cabeceraPosicionRanking" caption="**Tramo de mejora"
			sortable="true" />
		
		<pfs:defineHeader dataIndex="coeficiente"
			captionKey="plugin.recobroConfig.modeloFacturacion.corrector.cabeceraCoeficienteRanking" caption="**Coeficiente"
			sortable="true" renderer="app.format.percentRendererComa" />
			
	</pfs:defineColumnModel>
	
	var btnAgregarTramoCorrector = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.agregar" text="**Agregar" />'
		<app:test id="btnAgregarTramoCorrector" addComa="true" />
		,iconCls : 'icon_mas'
		,handler :  function(){
			w= app.openWindow({
				flow: 'recobromodelofacturacion/abrirTramoCorrector'
				,closable: true
				,width : 700
				,title : '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.nuevoTramoCorrector" text="Nuevo tramo corrector" />'
				,params: {idModFact:${idModFact}, idTramoCorrector: null}
			});
			w.on(app.event.DONE, function(){
				w.close();
				gridTramosCorrectores.store.webflow({idModFact:${idModFact}});
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});		
		}
	});	
	
	var editarTramoCorrector = function(){
		var rec = gridTramosCorrectores.getSelectionModel().getSelected();
			if (rec){
				var id = rec.get('id');
				w= app.openWindow({
					flow: 'recobromodelofacturacion/abrirTramoCorrector'
					,closable: true
					,width : 700
					,title : '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.editarTramoCorrector" text="Editar tramo corrector" />'
					,params: {idModFact:${idModFact}, 
							  idTramoCorrector: id}
				});
				w.on(app.event.DONE, function(){
					w.close();
					gridTramosCorrectores.store.webflow({idModFact:${idModFact}});
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});	
			} else {
				Ext.MessageBox.alert('<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.editarTramoCorrector" text="Editar tramo corrector" />',
					 '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.selecionarBorrar" text="**Seleccionar borrado"/>');
			}
	};
	
	var btnEditarTramoCorrector = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.politicaAcuerdos.editar" text="**Editar" />'
		<app:test id="btnEditarTramoCorrector" addComa="true" />
		,iconCls : 'icon_edit'
		,handler :  editarTramoCorrector
	});	
	
	var btnBorrar = new Ext.Button({
		text:'<s:message code="plugin.recobroConfig.modeloFacturacion.borrar" text="**Borrar"/>',
		iconCls: 'icon_menos',
		handler:function(){
			var rec = gridTramosCorrectores.getSelectionModel().getSelected();
			if (rec){
					var id = rec.get('id');
					Ext.MessageBox.confirm('Borrar tramo corrector'
						, '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.confirmarBorrar" text="**Confirmar borrado"/>'
						, function(btn){
							if (btn == 'yes'){
								Ext.Ajax.request({
									url: page.resolveUrl('recobromodelofacturacion/borrarTramoCorrector')
									,params: {
								  		idTramoCorrector: id
									}
									,method: 'POST'
									,success: function (result, request){
										gridTramosCorrectores.store.webflow({idModFact:${idModFact}});
										Ext.MessageBox.alert('Borrar reparto', '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.repartoBorrado" text="**Confirmar borrado"/>');
									}
								});
							}
						}
					);
			} else {
				Ext.MessageBox.alert('Borrar reparto', '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.selecionarBorrar" text="**Seleccionar borrado"/>');
			}
		}
	});
	
	 var gridTramosCorrectores = new Ext.grid.GridPanel({
        store: tramosCorrectoresDS
        ,cm: tramosCorrectoresCM
        ,title: '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.tituloListadoTramosCorrectores" text="**Tramos de corrección registrados"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding-top: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[btnBorrar, btnAgregarTramoCorrector, btnEditarTramoCorrector]
    });		
    
    gridTramosCorrectores.on('rowdblclick',editarTramoCorrector);
    
	var panel = new Ext.Panel({
		height:700
		,style:'margin:10px'
		,autoWidth:true
		,border: false
		,items:[datos,
				btnModificar
			]
	});
	
	if (tipoCorrectorValor != '--'){
		panel.add(gridTramosCorrectores)
	}
	
	if ('${modeloFacturacion.estado.codigo}'==ESTADO_BLOQUEADO.getValue() || '${modeloFacturacion.propietario.id}' != usuarioLogado.getValue()){
		btnModificar.setDisabled(true);
		btnBorrar.setDisabled(true); 
		btnAgregarTramoCorrector.setDisabled(true); 
		btnEditarTramoCorrector.setDisabled(true);
	} else {
		btnModificar.setDisabled(false);
		btnBorrar.setDisabled(false); 
		btnAgregarTramoCorrector.setDisabled(false); 
		btnEditarTramoCorrector.setDisabled(false);
		
	}	
	
	
	page.add(panel);
			
	
</fwk:page>	