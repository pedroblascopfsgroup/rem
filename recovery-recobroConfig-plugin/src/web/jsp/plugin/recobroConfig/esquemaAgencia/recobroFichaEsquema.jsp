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
	<pfs:hidden name="ESTADO_LIBERADO" value="${ESTADO_LIBERADO}"/>
	<pfs:hidden name="ESTADO_SIMULADO" value="${ESTADO_SIMULADO}"/>
	<pfs:hidden name="ESTADO_PENDIENTESIMULAR" value="${ESTADO_PENDIENTESIMULAR}"/>
	<pfs:hidden name="ESTADO_EXTINCION" value="${ESTADO_EXTINCION}"/>
	<pfs:hidden name="ESTADO_DESACTIVADO" value="${ESTADO_DESACTIVADO}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	
	ultimaVersionDelEsquema=${ultimaVersionDelEsquema};
		
	<pfsforms:textfield name="nombre" labelKey="plugin.recobroConfig.fichaEsquema.nombre" 
		label="**Nombre" value="${esquema.nombreVersion}" readOnly="true" />
	
	<pfsforms:textfield name="propietario" labelKey="plugin.recobroConfig.fichaEsquema.usuarioPropietario" 
		label="**Propietario" value="${esquema.propietario.username}" readOnly="true" />
		
	<pfsforms:textfield name="descripcion" labelKey="plugin.recobroConfig.fichaEsquema.descripcion" 
		label="**Descripción" value="${esquema.descripcion}" readOnly="true" width="800"/>

	<pfsforms:textfield name="estado" labelKey="plugin.recobroConfig.fichaEsquema.estado" 
		label="**Estado" value="${esquema.estadoEsquema.descripcion}" readOnly="true" />
	
	<pfsforms:textfield name="plazo" labelKey="plugin.recobroConfig.fichaEsquema.plazoActivacion" 
		label="**Plazo de días hasta fin de transición" value="${esquema.plazo}" readOnly="true" />

	plazo.labelStyle = 'font-weight:bold; width:120px;'
	nombre.labelStyle = 'font-weight:bold; width:120px;'
	estado.labelStyle = 'font-weight:bold; width:120px;'
	
	<pfsforms:textfield name="modeloTransicion" labelKey="plugin.recobroConfig.fichaEsquema.modeloTransicion" 
		label="**Modelo de Transición" value="${esquema.modeloTransicion.descripcion}" readOnly="true" />
	
	
	var datos = new Ext.form.FieldSet({
		style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,autoWidth:true
		,title:'<s:message code="plugin.recobroConfig.fichaEsquema.titulo.datos" text="**Datos generales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		,items :[{items:[estado,nombre,plazo]} ,{items : [propietario,descripcion,modeloTransicion]} ]
	});
	
	<pfsforms:textfield name="alta" labelKey="plugin.recobroConfig.fichaEsquema.fechaAlta" 
		label="**Fecha Alta" value="${fechaAltaFormat}" readOnly="true" />
	
	<pfsforms:textfield name="liberado" labelKey="plugin.recobroConfig.fichaEsquema.fechaLiberado" 
		label="**Fecha Liberado" value="${fechaLiberacionFormat}" readOnly="true" />
	
	<pfsforms:textfield name="transicion" labelKey="plugin.recobroConfig.fichaEsquema.fechaTransicion" 
		label="**Fecha Transición" value="${fechaFinTransFormat}" readOnly="true" />
	
	alta.labelStyle = 'font-weight:bold; width:120px;'
	liberado.labelStyle = 'font-weight:bold; width:120px;'
	transicion.labelStyle = 'font-weight:bold; width:120px;'
	
	<pfsforms:textfield name="esquemaAnt" labelKey="plugin.recobroConfig.fichaEsquema.esquemaAnterior" 
		label="**Esquema Anterior" value="${esquemaAnterior.nombre}" readOnly="true" />
	
	<pfsforms:textfield name="esquemaSig" labelKey="plugin.recobroConfig.fichaEsquema.esquemaSiguiente" 
		label="**Esquema Siguiente" value="${esquemaSiguiente.nombre}" readOnly="true" />
	
	esquemaAnt.labelStyle = 'font-weight:bold; width:120px;'
	esquemaSig.labelStyle = 'font-weight:bold; width:120px;'
	
	var eventos = new Ext.form.FieldSet({
		style:'margin-top:10px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,height:150
		,autoWidth:true
		,title:'<s:message code="plugin.recobroConfig.fichaEsquema.titulo.eventos" text="**Eventos"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		,items :[{items:[alta,liberado,transicion]} ,{items : [esquemaAnt,esquemaSig]} ]
	});	
	
	var idEsquema = '${esquema.id}';
    
	var loadPanelEsquema = function(title, flow, params){
		var contenido = Ext.getCmp("contEsquema_${esquema.id}");
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
	
	var recargar = function (){
		loadPanelEsquema('<s:message code="plugin.recobroConfig.esquemaAgencia.consulta.botones.esquema" text="**Esquema"/>', "recobroesquema/abrirFichaEsquema",{idEsquema:idEsquema,ultimaVersionDelEsquema:ultimaVersionDelEsquema});           				
	};
	
	
	var btnModificar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.fichaEsquema.modificar" text="**Modificar" />'
		,iconCls : 'icon_edit'
		,iconAlign: 'right'
		,width: 75
		,handler : 	function() {
			var parms = {};
    		parms.idEsquema='${esquema.id}';
			var w = app.openWindow({
				flow: 'recobroesquema/editarRecobroEsquema'
				,closable: true
				,width : 700
				,title :  '<s:message code="plugin.recobroConfig.fichaEsquema.editarEsquema" text="**Editar Esquema"/>'
				,params: parms
			});
			w.on(app.event.DONE, function(){
				recargar();
				w.close();
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});	
		}
	});
	
	var btnSimular = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.fichaEsquema.simular" text="**Simular" />'
		,iconCls : 'icon_simulacion'
		,iconAlign: 'right'
		,width: 75
		,handler : 	function() {
			Ext.Msg.confirm('<s:message code="plugin.recobroConfig.fichaEsquema.simular" text="**Simular" />', '<s:message code="plugin.recobroConfig.fichaEsquema.simular.confirmar" text="**El esquema quedará pendiente de simular por el Batch ¿Está seguro?" />', function(btn){				
    			if (btn == "yes") {
	    			var parms = {};
    				parms.idEsquema='${esquema.id}';
    				parms.codEstado='${COD_ESTADO_ESQUEMA_PENDIENTESIMULAR}';
	    			Ext.Ajax.request({
						url: app.resolveFlow('recobroesquema/cambiarEstadoRecobroEsquema')
						,params: parms
						,method: 'POST'
						,success: function (result, request){
        					var r = Ext.util.JSON.decode(result.responseText);
       					 	if(r.success) {
								recargar();
								var botonSimulacion = Ext.getCmp("btn_5_esquema_${esquema.id}");
								botonSimulacion.setDisabled(false);
							}
						}
						,failure: function(){
							Ext.Msg.alert('<s:message code="plugin.recobroConfig.fichaEsquema.simular" text="**Simular" />','<s:message code="plugin.recobroConfig.fichaEsquema.simular.error" text="**Ha ocurrido un error y no se ha podido simular el esquema" />');
						}
					})
				}
			});
		}
	});
	
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,id: 'btLiberarRecobroFichaEsquema'
		,handler : function(){
    			var parms = {};
    			parms.idEsquema='${esquema.id}';
    			page.webflow({
					flow: 'recobroesquema/liberarEsquemaRecobro'
					,params: parms
					,success : function(){ 
						recargar();
					}
				});
		}
	});	
	
	var btDefinicion= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.pasarDefinicion" text="**Definición" />'
		,iconCls : 'icon_marcar_pte'
		,disabled : true
		,id: 'btDefinicionRecobroFichaEsquema'
		,handler : function(){
    			var parms = {};
    			parms.idEsquema='${esquema.id}';
    			page.webflow({
					flow: 'recobroesquema/cambiarEstadoDefinicion'
					,params: parms
					,success : function(){ 
						recargar();
					}
				});
		}
	});
	
	var panelBotones = new Ext.form.FieldSet({
		style:'padding:0px'
 		,border:false
		,layout : 'table'
		,layoutConfig:{
			columns:3
		}
		,autoWidth:true
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:100,style:'padding:0 0 0 0'}
		,items :[{items:[btnSimular]} ,{items : [btLiberar]},{items : [btDefinicion]} ]
	}); 
	
	var panel = new Ext.Panel({
		height:700
		,autoWidth:true
		,bodyStyle:'padding: 10px'
		,items:[datos,
				btnModificar,
				eventos,
				panelBotones
			]
	});
	
	 btnSimular.setDisabled(true);
     btnModificar.setDisabled(true);
     btDefinicion.setDisabled(true);

     <sec:authorize ifAllGranted="ROLE_CONF_ESQUEMA">
             btnSimular.setDisabled(false);
             btnModificar.setDisabled(false);
             btDefinicion.setDisabled(false);
     </sec:authorize>

     if (!ultimaVersionDelEsquema ) {
             btnSimular.setDisabled(true);
             btnModificar.setDisabled(true);
             btDefinicion.setDisabled(true);
     }

     if ('${esquema.estadoEsquema.codigo}' != 'DEF'){
             btnSimular.setDisabled(true);
     }
	 
	if (ESTADO_SIMULADO.getValue()=='${esquema.estadoEsquema.codigo}' || ESTADO_PENDIENTESIMULAR.getValue()=='${esquema.estadoEsquema.codigo}'){
	        <sec:authorize ifAllGranted="ROLE_CONF_ESQUEMA">
	        btDefinicion.setDisabled(false);
	        </sec:authorize>
	} else{
	        btDefinicion.setDisabled(true);
	}
	
	if ( ${enEstadoCorrectoLiberar} && ultimaVersionDelEsquema){
	        <sec:authorize ifAllGranted="ROLE_CONF_ESQUEMA">
	        btLiberar.setDisabled(false);
	        </sec:authorize>
	} else {
	        btLiberar.setDisabled(true);
	}
	
	if ('${esquema.estadoEsquema.codigo}' == ESTADO_LIBERADO.getValue()){
	        btnModificar.setDisabled(true);
	}
		
	page.add(panel);
			
	
</fwk:page>	