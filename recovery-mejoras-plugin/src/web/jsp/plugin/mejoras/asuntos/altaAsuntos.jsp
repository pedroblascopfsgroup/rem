<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>

	var style='margin-bottom:1px;margin-top:1px;width:250px';
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;';
	var labelStyle2='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:30px';
	
	var cambioGestor=false;
	var cambioSupervisor=false;
	var esGestor=false;
	
	<c:if test="${cambioGestor!=null}">
		cambioGestor=true;
	</c:if> 
	<c:if test="${cambioSupervisor!=null}">
		cambioSupervisor=true;
	</c:if> 
	
	
	
	// Emilio
		
	var listTiposGestorAsuntoUsuarioLogado = [
	    <c:if test="${listTiposGestorAsuntoUsuarioLogado!=null}">	
	    	<c:forEach items="${listTiposGestorAsuntoUsuarioLogado}" var="lista" varStatus="loop">
	     	   "${lista.codigo}" ${!loop.last ? ',' : ''}
	   		</c:forEach>  
        </c:if>  
     ];
	
	var soyDeEsteTipoGestor=function(strCodTipogestor){
	    var bReturn = false;
	    var i;	    	    	 	    	    	    	
	        
	    for (i=0; i<=(listTiposGestorAsuntoUsuarioLogado.length-1); i++)
	    {	    
	    	if(listTiposGestorAsuntoUsuarioLogado[i] == strCodTipogestor)
	    	{
	    	    bReturn = true;
	    	    break;
	    	}	    	
	    }	
		    
	    <c:if test="${listTiposGestorAsuntoUsuarioLogado==null}">
		    bReturn = true;
	    </c:if>		    	       	   
	        	    
	    <sec:authorize ifAllGranted="CAMBIAR-GESTORHP">    	       	   
	    	    bReturn = true;
 	    </sec:authorize>	        	    
	        	    
	    return bReturn;
	};

	// Sergio, los supervisores pueden cambiar el despacho cex
	if (soyDeEsteTipoGestor("SUP")) {
		listTiposGestorAsuntoUsuarioLogado[listTiposGestorAsuntoUsuarioLogado.length] = 'SUPCEXP';
	}
	if (soyDeEsteTipoGestor("SUPCEXP")) {
		listTiposGestorAsuntoUsuarioLogado[listTiposGestorAsuntoUsuarioLogado.length] = 'SUP';
	}
	// Fin sergio

    var getStrTipoDespacho=function(){
        var strTipoDespacho = "";
        
        if(!cambioGestor && !cambioSupervisor)
            strTipoDespacho = "COMITE";
        else
        {
	    	if(soyDeEsteTipoGestor("GEXT") || soyDeEsteTipoGestor("SUP")) 
	    	    strTipoDespacho =  '<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO" />';  	
	    	else if(soyDeEsteTipoGestor("GECEXP") || soyDeEsteTipoGestor("SUPCEXP"))
	    	    strTipoDespacho =  '<fwk:const value="es.pfsgroup.plugin.recovery.mejoras.PluginMejorasCodigosConstants.CODIGO_DESPACHO_CONFECCION_EXPEDIENTE" />';
    	}    
    	
    	return strTipoDespacho; 
    } 					
			
    // Emilio Fin	
    	
	
	var txtNombreAsunto = app.creaText('asunto',
		'<s:message code="edicionAsunto.asunto" text="**Asunto" />',
		<c:if test="${asuntoEditar!=null}" >
			'<s:message text="${asuntoEditar.nombre}" javaScriptEscape="true" />',
		</c:if>
		<c:if test="${asuntoEditar==null}" >
			'<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />',
		</c:if>
		{style:style,labelStyle:labelStyle,disabled:cambioGestor||cambioSupervisor});
		
	/*Jerarquía*/
	var zonas=<app:dict value="${zonas}" />;
	
	var listaJerarquia = <fwk:json>
							<json:array name="jerarquia" items="${niveles}" var="s">
								<json:object>
									<json:property name="id" value="${s.id}" />
									<json:property name="descripcion" value="${s.descripcion}" />
								</json:object>
							</json:array>
						</fwk:json>;
	
	<pfsforms:combo name="comboJerarquia" 
		dict="listaJerarquia" 
		displayField="descripcion" 
		root="jerarquia" 
		labelKey="menu.clientes.listado.filtro.jerarquia"
		label="**Jerarquia"
		value="0" 
		valueField="id"/>
		
	comboJerarquia.disabled=cambioGestor||cambioSupervisor;	
	
    var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'clientes/buscarAllZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
    
    
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas,disabled:cambioGestor||cambioSupervisor,labelStyle:labelStyle2});
	/*Fin jerarquia*/

	var recargarCombosGestoresProcuradores=function(){
		if(comboZonas.getValue()!=''){
			//recargar combo despachos externos
			optionsDespachosStore.webflow({
				zonas:comboZonas.getValue()
				,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO" />'
			});
			//recargar combo despachos procuradores
			optionsDespachosProcuradoresStore.webflow({
				zonas:comboZonas.getValue()
				,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'
			});
			//recargar combo despachos confección expedientes (DCEXP) Emilio
			optionsDespachosCEXPStore.webflow({
				zonas:comboZonas.getValue()
				,tipoDespacho:'<fwk:const value="es.pfsgroup.plugin.recovery.mejoras.PluginMejorasCodigosConstants.CODIGO_DESPACHO_CONFECCION_EXPEDIENTE" />'
			});
			// Emilio Fin
			comboDespachosExternos.clearValue();
			comboDespachosProcuradores.clearValue();
			comboGestores.clearValue();
			comboSupervisores.clearValue();
			comboProcuradores.clearValue();
			
			//confección expedientes Emilio
			comboDespachosCEXP.clearValue();			
			comboGestoresCEXP.clearValue();
			comboSupervisoresCEXP.clearValue();			
			//Emilio Fin
		}	
	}
	comboZonas.on('change',function(){
		
	});
	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
			comboZonas.setValue('');
			optionsZonasStore.removeAll();
		}
	}
	
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
	recargarComboZonas();	
	
	var despachosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'tipo'}
		,{name:'codigo'}
		,{name:'nombre'}
	]);
    
    var optionsDespachosStore = page.getStore({
	       flow: 'asuntos/buscarDespachosPorZona'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'despachos'
	    }, despachosRecord)
	       
	});

	// DOV - 14/12/2011 Los gestores NO pueden cambiar el despacho de un Asunto
	var comboDespachosExternos = new Ext.form.ComboBox({
				store:optionsDespachosStore
				,displayField:'nombre'
				,valueField:'codigo'
				,mode: 'local'
				,autoWidth:true
				,resizable: true			
				,triggerAction: 'all'
				,emptyText:'---'
				,labelStyle:labelStyle
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.despacho" text="**Despacho"/>'
				<c:if test="${asuntoEditar!=null}" >
					,value:'${asuntoEditar.gestor.despachoExterno.id}'
				</c:if>
				,disabled: !soyDeEsteTipoGestor("SUP") 				
				<c:if test="${tienePerfilGestor==true}" >
					,disabled:true
				</c:if>
				<app:test id="comboDespachosAA" addComa="true"/>
	});	
	comboDespachosExternos.on('focus',recargarCombosGestoresProcuradores);	
	
	var optionsDespachosProcuradoresStore = page.getStore({
	       flow: 'asuntos/buscarDespachosPorZona'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'despachos'
	    }, despachosRecord)
	       
	});
	var comboDespachosProcuradores = new Ext.form.ComboBox({
				store:optionsDespachosProcuradoresStore
				,displayField:'nombre'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false	
				,autoWidth:true
				,resizable: true			
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,emptyText:'---'
				,allowBlank:true
				,disabled:cambioSupervisor
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.despacho" text="**Despacho"/>'
				<c:if test="${asuntoEditar!=null}" >
					,value:'${asuntoEditar.procurador.despachoExterno.id}'
				</c:if>
	});
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var</c:if> recargarComboGestores = function(){
		optionsGestoresStore.webflow({id:comboDespachosExternos.getValue()});
		optionsSupervisoresStore.webflow({id:comboDespachosExternos.getValue()});
		comboGestores.enable();
		comboGestores.focus();
		comboSupervisores.enable();
	}
	<%--
	var recargarComboProcuradores = function(){
		optionsProcuradoresStore.webflow({id:comboDespachosProcuradores.getValue()});
		comboProcuradores.enable();
		comboProcuradores.focus();
	}--%>
	
	var recargarComboProcuradores = function(){
		dsProcuradores.load({params:{id:comboDespachosProcuradores.getValue()}});
		dsProcuradores.baseParams.id=comboDespachosProcuradores.getValue();
		comboProcuradores.setValue();
		comboProcuradores.enable();
		comboProcuradores.focus();
	}
	
	var bloquearComboGestores = function(){
		comboGestores.disable();
		comboGestores.reset();
		comboSupervisores.disable();
		comboSupervisores.reset();
	}
	
	comboDespachosExternos.on('focus',bloquearComboGestores);
	
	comboDespachosExternos.on('select',recargarComboGestores);
	
	comboDespachosProcuradores.on('select',recargarComboProcuradores);
	
	<%--AÑADIR FUNCIONALIDAD DE COMBO PAGINADO CON BUSQUEDA PARA PROCURADORES --%>
	var codProcurador = '';
	var decenaInicio = 0;
	
	var dsProcuradores = new Ext.data.Store({
		autoLoad:false,
		baseParams: {limit:10, start:0, id:comboDespachosProcuradores.getValue(),tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('plugin/mejoras/asuntos/plugin.mejoras.asuntos.buscaGestoresByDescripYDespacho')
		}),
		reader: new Ext.data.JsonReader({
			root: 'gestores'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	  
	var comboProcuradores = new Ext.form.ComboBox ({
		store:  dsProcuradores,
		id: 'comboProcuradores',
		allowBlank: true,
		blankElementText: '--',
		disabled: false,
		labelStyle:labelStyle,
		style:style,
		displayField: 'descripcion', 	
		valueField: 'codigo', 		
		fieldLabel: '<s:message code="asuntos.alta.gestor" text="**Procurador" />',		
		hiddenName:'${asuntoEditar.procurador.id}',
		loadingText: 'Searching...',
		width: 200,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'remote'
		,value:'${asuntoEditar.procurador.id}'
	});	
	comboProcuradores.setWidth(270);
	
	codProcurador='${asuntoEditar.procurador.id}';

	Ext.onReady(function() {
		decenaInicio = 0;
		if (codProcurador!=''){
			Ext.Ajax.request({
					url: page.resolveUrl('plugin/mejoras/asuntos/plugin.mejoras.asuntos.buscaGestoresById')
					,params: {codigo: codProcurador,id:comboDespachosProcuradores.getValue(),tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText)
						decenaInicio = (r.paginaParaGestor);
						dsProcuradores.setBaseParam('start',decenaInicio);
						comboProcuradores.store.reload();
						dsProcuradores.on('load', function(){ 
							comboProcuradores.setValue(codProcurador);
							dsProcuradores.events['load'].clearListeners();
						});
					}				
			});
		}
	});

	var Gestor = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsGestoresStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	var comboGestores = new Ext.form.ComboBox({
				store:optionsGestoresStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,disabled: !cambioGestor || !soyDeEsteTipoGestor("GEXT") && !soyDeEsteTipoGestor("SUP")
				,fieldLabel : '<s:message code="asuntos.alta.gestor" text="**Gestor"/>'
				,name: 'comboGestores'
				<app:test id="comboGestoresAA" addComa="true"/>
				
	});


	var labelTipoGestor = new Ext.form.Label({
		text:'[Externo]'
		,style:'valgin:center'
	});
	
	var optionsSupervisoresStore = page.getStore({
	       flow: 'asuntos/buscarSupervisoresDespachos'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	var comboSupervisores = new Ext.form.ComboBox({
				store:optionsSupervisoresStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 				
				,emptyText:'---'
				,autoWidth:true
				,resizable: true			
				,mode: 'remote'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,disabled: !cambioSupervisor || !soyDeEsteTipoGestor("GEXT") && !soyDeEsteTipoGestor("SUP")
				,fieldLabel : '<s:message code="asuntos.alta.supervisor" text="**Supervisor"/>'
				,name: 'comboSupervisores'
				<app:test id="comboSupervisoresAA" addComa="true"/>
	});
	
	
	<%-- Emilio	--%>		
	
	var optionsDespachosCEXPStore = page.getStore({
	       flow: 'asuntos/buscarDespachosPorZona'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'despachos'
	    }, despachosRecord)
	       
	});
	
	var comboDespachosCEXP = new Ext.form.ComboBox({
				store:optionsDespachosCEXPStore
				,displayField:'nombre'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false	
				,autoWidth:true
				,resizable: true			
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,emptyText:'---'
				,allowBlank:true				
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.despacho" text="**Despacho"/>'
				<c:if test="${asuntoEditar!=null}" >
					,value:'${asuntoEditar.gestorCEXP.despachoExterno.id}'
				</c:if>
				,disabled: !soyDeEsteTipoGestor("SUPCEXP")
				<c:if test="${tienePerfilGestor==true}" >
					,disabled:true
				</c:if>				
	});
	
	
	var optionsGestoresCEXPStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	var comboGestoresCEXP = new Ext.form.ComboBox({
				store:optionsGestoresCEXPStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 
				,disabled:true
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style	
				,disabled:!cambioGestor	 || !soyDeEsteTipoGestor("GECEXP") && !soyDeEsteTipoGestor("SUPCEXP")		
				,fieldLabel : '<s:message code="asuntos.alta.gestor" text="**Gestor"/>'
				,name: 'comboGestoresCEXP'
				<app:test id="comboGestoresCEXPAA" addComa="true"/>
				
	});
		
    var optionsSupervisoresCEXPStore = page.getStore({
	       flow: 'asuntos/buscarSupervisoresDespachos'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});	
	
	var comboSupervisoresCEXP = new Ext.form.ComboBox({
				store:optionsSupervisoresCEXPStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,forceSelection:true 
				,disabled:true
				,emptyText:'---'
				,autoWidth:true
				,resizable: true			
				,mode: 'remote'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style	
				,disabled:!cambioSupervisor || !soyDeEsteTipoGestor("GECEXP") && !soyDeEsteTipoGestor("SUPCEXP")			
				,fieldLabel : '<s:message code="asuntos.alta.supervisor" text="**Supervisor"/>'
				,name: 'comboSupervisoresCEXP'
				<app:test id="comboSupervisoresCEXPAA" addComa="true"/>
	});
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var</c:if> recargarComboGestoresCEXP = function(){
		optionsGestoresCEXPStore.webflow({id:comboDespachosCEXP.getValue()});
		optionsSupervisoresCEXPStore.webflow({id:comboDespachosCEXP.getValue()});
		comboGestoresCEXP.enable();
		comboGestoresCEXP.focus();
		comboSupervisoresCEXP.enable();
	}
	
	
	comboDespachosCEXP.on('select',recargarComboGestoresCEXP);
	
	var bloquearComboGestoresCEXP = function(){
		comboGestoresCEXP.disable();
		comboGestoresCEXP.reset();
		comboSupervisoresCEXP.disable();
		comboSupervisoresCEXP.reset();
	}
	
	<c:if test="${asuntoEditar!=null && (asuntoEditar.gestorCEXP!=null || asuntoEditar.gestor!=null)}" >
	
	    var setGestorCEXPValue = function(){	        	                
			comboGestoresCEXP.setValue('${asuntoEditar.gestorCEXP.id}');			 
			//comboGestoresCEXP.setDisabled(cambioSupervisor);			    
			comboGestoresCEXP.setDisabled(cambioSupervisor || !soyDeEsteTipoGestor("GECEXP") && !soyDeEsteTipoGestor("SUPCEXP"));	
			     
			optionsGestoresCEXPStore.un('load',setGestorCEXPValue);
		};
	
		var setSupervisorCEXPValue = function(){
			comboSupervisoresCEXP.setValue('${asuntoEditar.supervisorCEXP.id}');
		    		   
		    comboSupervisoresCEXP.setDisabled( cambioGestor || !soyDeEsteTipoGestor("GECEXP") && !soyDeEsteTipoGestor("SUPCEXP"));
		    		    
	        /*
	        if(cambioGestor)
				comboSupervisoresCEXP.disable();
			else
				comboSupervisoresCEXP.enable();
			*/			     			
			
			optionsSupervisoresCEXPStore.un('load',setSupervisorCEXPValue);
		};
		
		var setDespachoCEXPValue = function(){
			comboDespachosCEXP.setValue('${asuntoEditar.gestorCEXP.despachoExterno.id}');
			optionsDespachosCEXPStore.un('load',setDespachoCEXPValue);	
		};
		
		optionsGestoresCEXPStore.on('load',setGestorCEXPValue);
		optionsSupervisoresCEXPStore.on('load',setSupervisorCEXPValue);		
		optionsDespachosCEXPStore.on('load',setDespachoCEXPValue);				
		
		<%-- Sergio: el supervisor judicial puede cambiar el gestor y supervisor CEX --%>
		<c:if test="${asuntoEditar.gestorCEXP.despachoExterno.id!=null}" >
			optionsGestoresCEXPStore.webflow({id:${asuntoEditar.gestorCEXP.despachoExterno.id}});	
			optionsSupervisoresCEXPStore.webflow({id:${asuntoEditar.gestorCEXP.despachoExterno.id}});
		</c:if>
		<%-- Sergio --%>

		//recargar combo despachos externos CEXP
		optionsDespachosCEXPStore.webflow({
			zonas:'${asuntoEditar.gestorCEXP.despachoExterno.zona.codigo}'
			,tipoDespacho:'<fwk:const value="es.pfsgroup.plugin.recovery.mejoras.PluginMejorasCodigosConstants.CODIGO_DESPACHO_CONFECCION_EXPEDIENTE" />'
		});
	
	
	</c:if>									         	
	
	<%-- Emilio	Fin --%>
	
	
	<c:if test="${asuntoEditar!=null && asuntoEditar.gestor!=null}" >
	
		var setGestorValue = function(){		    	   
			comboGestores.setValue('${asuntoEditar.gestor.id}');			
		    //comboGestores.setDisabled(cambioSupervisor);
		    comboGestores.setDisabled(cambioSupervisor || !soyDeEsteTipoGestor("GEXT") && !soyDeEsteTipoGestor("SUP"));
				
			optionsGestoresStore.un('load',setGestorValue);						
		}
	
		var setSupervisorValue = function(){		     
			comboSupervisores.setValue('${asuntoEditar.supervisor.id}');
						
			comboSupervisores.setDisabled(cambioGestor || !soyDeEsteTipoGestor("GEXT") && !soyDeEsteTipoGestor("SUP"));
			/*
			if(cambioGestor)
				comboSupervisores.disable();
			else
				comboSupervisores.enable();
			*/				
			   
			optionsSupervisoresStore.un('load',setSupervisorValue);
		}
		var setProcuradorValue = function (){
			//alert('setProcuradorValue');			 
			comboProcuradores.setValue('${asuntoEditar.procurador.id}');
			comboProcuradores.setDisabled(cambioSupervisor);
			dsProcuradores.un('load',setProcuradorValue);
		}
		var setDespachoExternoValue = function(){
			comboDespachosExternos.setValue('${asuntoEditar.gestor.despachoExterno.id}');
			optionsDespachosStore.un('load',setDespachoExternoValue);	
		}
		var setDespachoProcuradorValue=function(){		    
			comboDespachosProcuradores.setValue('${asuntoEditar.procurador.despachoExterno.id}');
			comboDespachosProcuradores.setDisabled(cambioSupervisor);
			optionsDespachosProcuradoresStore.un('load',setDespachoProcuradorValue);
		}
		optionsGestoresStore.on('load',setGestorValue);
		optionsSupervisoresStore.on('load',setSupervisorValue);
		optionsDespachosProcuradoresStore.on('load',setDespachoProcuradorValue);
		
		//dsProcuradores.on('load',setProcuradorValue);
		
		optionsDespachosStore.on('load',setDespachoExternoValue);
		//recargar combo despachos externos
		optionsDespachosStore.webflow({
			zonas:'${asuntoEditar.gestor.despachoExterno.zona.codigo}'
			,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO" />'
		})
		<c:if test="${asuntoEditar.procurador!=null}" >
		//recargar combo despachos procuradores, si el asunto tiene procurador
		optionsDespachosProcuradoresStore.webflow({
			zonas:'${asuntoEditar.procurador.despachoExterno.zona.codigo}'
			,tipoDespacho:'<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'
		});
		<%-- 
		optionsProcuradoresStore.webflow({
			id: '${asuntoEditar.procurador.despachoExterno.codigo}'
		});--%>
		</c:if>
		optionsGestoresStore.webflow({id:${asuntoEditar.gestor.despachoExterno.id}});
		optionsSupervisoresStore.webflow({id:${asuntoEditar.gestor.despachoExterno.id}});
		
	</c:if>
	

	
	
	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,style:'font-weight:bolder; font-size:11'
	}); 
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,width:810
		//,hideLabel:true
		,height:100
		,labelSeparator:''
		,labelStyle:labelStyle
		,disabled:cambioGestor||cambioSupervisor
		<c:if test="${asuntoEditar!=null}" >
			,value:'<s:message text="${asuntoEditar.observacion}" javaScriptEscape="true" />'
		</c:if>	
		<app:test id="observaciones" addComa="true"/>	
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
		<%-- 
			var mismoprocurador=comboProcuradores.getValue();
			if('${asuntoEditar}'!=''){
				if('${asuntoEditar.procurador.id}'==comboProcuradores.getValue()){
					mismoprocurador=null;
				}
			}--%>
			page.submit({
				formPanel: panelAlta
				,eventName : 'saveAsunto'
				,params: {
					idGestor:comboGestores.getValue() 
					,idSupervisor:comboSupervisores.getValue()
					,nombreAsunto:txtNombreAsunto.getValue()
                    <c:if test="${idExpediente!=null}" >
					   ,idExpediente:${idExpediente}
                    </c:if>     
					,observaciones:observaciones.getValue()
					<c:if test="${asuntoEditar!=null}" >
						,idAsunto: ${asuntoEditar.id}
					</c:if>
					,idProcurador:comboProcuradores.getValue()
					<%-- Emilio --%>
					,idGestorConfeccionExpediente:comboGestoresCEXP.getValue() 
					,idSupervisorConfeccionExpediente:comboSupervisoresCEXP.getValue()
					,tipoDespacho: getStrTipoDespacho()
					<%--  Emilio Fin --%>					
				}
				,success :  function(){ 
                  				page.fireEvent(app.event.DONE);
                  			}
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});

	var panelDespachosGestores=new Ext.Panel({
		layout:'table'
		,layoutConfig:{columns:3}
		,autoHeight:true
		,border:false
		,style:'padding-left:10px'
		,cellCls:'vtop'
		,width:900
		,defaults:{xtype:'fieldset',height:120}		
		,items:[
			{
				title:'<s:message code="asuntos.despachoExterno" text="**Despacho Externo" />'
				,items:[comboDespachosExternos,comboGestores,comboSupervisores]
			}
			,{
				border:false
				,style:'width:5px'
			},
			{
				title:'<s:message code="asuntos.despachoProcurador" text="**Despacho Procurador" />'
				,items:[comboDespachosProcuradores,comboProcuradores]
			}
		]
	});
	
	<%-- Emilio	--%>
	var panelDespachosCEXP=new Ext.Panel({
		layout:'table'
		,layoutConfig:{columns:1}
		,autoHeight:true
		,border:false
		,style:'padding-left:10px'
		,cellCls:'vtop'
		,width:900
		,defaults:{xtype:'fieldset',height:120}		
		,items:[
			{
				title:'<s:message code="plugin.mejoras.asuntos.despachoCEXP" text="**Despacho C. Expediente" />'
				,items:[comboDespachosCEXP,comboGestoresCEXP,comboSupervisoresCEXP]
			}			
		]
	});
	<%-- Emilio	Fin --%>
	
	
	var panelAlta = new Ext.form.FormPanel({
		bodyStyle : 'padding-left:5px;padding-top:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		autoHeight:true
		 		,border:false
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true}
		 		,items:[ 
		 			{
						layout:'table'
						,layoutConfig:{columns:3}
						,autoHeight:true
						,border:false
						,style:'padding-left:10px'
						,cellCls:'vtop'
						,width:900
						,defaults:{xtype:'fieldset',border:false,autoHeight:true}
						,items:[
							{
								items:[txtNombreAsunto,comboJerarquia]
							},{
								items:[comboZonas]
								,style:'padding:5px'
							}
						]
					}
					,panelDespachosGestores	
					,panelDespachosCEXP	
		 			,{
						items:[observaciones]
						,labelAlign:'top'
					}
		 		]
		 	}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	//Cargo el combo de Despachos de procuraores si se hace un cambio de gestor
	panelAlta.on('afterrender',function(){
		if (cambioGestor) {
			//recargar combo despachos procuradores
			optionsDespachosProcuradoresStore.webflow({
				zonas: '${asuntoEditar.comite.zona.codigo}',
				tipoDespacho: '<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR" />'
			});
			comboDespachosProcuradores.reset();
			comboDespachosExternos.reset();
		};
	});

	page.add(panelAlta);

</fwk:page>