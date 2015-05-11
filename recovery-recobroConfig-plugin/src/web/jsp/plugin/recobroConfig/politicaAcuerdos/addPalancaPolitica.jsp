<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	
	<pfsforms:ddCombo name="comboPalancas"
		labelKey="plugin.recobroConfig.politicaAcuerdos.palanca.tipoPalanca" label="**Tipo de Palanca"
		value="" dd="${tiposPalanca}" width="200" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" obligatory="true" />
	
	 	
	comboPalancas.setValue('${palanca.subtipoPalanca.tipoPalanca.codigo}');	
	
		
	var subTipoPalancaRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var subTipoPalancaStore = page.getStore({
	       flow: 'recobropoliticadeacuerdos/getSubtiposPalanca'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'subpalancas'
	    }, subTipoPalancaRecord)
	       
	}); 
	
	var filtroSubTipoPalanca =new Ext.form.ComboBox({
		store: subTipoPalancaStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.recobroConfig.politicaAcuerdos.subtipospalancas" text="**SubTipo palanca" />'
		,width:200
		,value:''
		
	});	
	
		
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarSubtipoPalanca = function(){
		if (comboPalancas.getValue()!=null && comboPalancas.getValue()!=''){
			subTipoPalancaStore.webflow({codigoTipoPalanca:comboPalancas.getValue()});
			subTipoPalancaStore.on('load', function(){  
				filtroSubTipoPalanca.setValue('');
			});
		}else{
			subTipoPalancaStore.webflow({codigoTipoPalanca:0});
			subTipoPalancaStore.on('load', function(){  
				filtroSubTipoPalanca.setValue('');
			});
		}
	};
	
    recargarSubtipoPalanca();
    
    var limpiarYRecargar = function(){
		recargarSubtipoPalanca();
	}
	
	comboPalancas.on('select',limpiarYRecargar);	
	
	Ext.onReady(function() {
    	if (comboPalancas.getValue()!=null && comboPalancas.getValue()!=''){
			subTipoPalancaStore.webflow({codigoTipoPalanca:comboPalancas.getValue()});
			subTipoPalancaStore.on('load', function(){  
				filtroSubTipoPalanca.setValue('${palanca.subtipoPalanca.codigo}');
				subTipoPalancaStore.events['load'].clearListeners();
			});
		}
    });	
    	
	<pfsforms:ddCombo name="comboSiNo"
		labelKey="plugin.recobroConfig.politicaAcuerdos.palanca.delegada" label="**Delegada"
		value="${carteraEsquema.tipoGestionCarteraEsquema.id}" dd="${ddSiNo}" width="200" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" obligatory="true" />
	
	 	
	comboSiNo.setValue('${palanca.delegada.codigo}');
		
		
	var datosPrioridad = new Array();
   	for (i=1;i<=${maxPrioridad};i++) {
   		datosPrioridad.push(new Array(i,'Prioridad '+i));
   	}
  	
  	
	var cmbPrioridad = new Ext.form.ComboBox({
			name:'cmbPrioridad'
			,hiddenName:'comboPrioridad'
			,store:datosPrioridad
			,displayField:'descripcion'
			,valueField:'id'
			,mode: 'local'
			,style:'margin:0px'
			,triggerAction: 'all'
			//,labelStyle:labelStyle
			,disabled:false
			,fieldLabel : '<s:message code="plugin.recobroConfig.carteraEsquema.prioridad" text="**Prioridad" />'
	});	
	
	
	
	 
	cmbPrioridad.setValue('${palanca.prioridad}');
	
	
	<pfs:numberfield name="tiempoInmunidad1" labelKey="plugin.recobroConfig.carteraEsquema.inmunidad.uno" 
		label="**Tiempo Inmunidad 1" value="${palanca.tiempoInmunidad1}" obligatory="false" allowNegative="false" allowDecimals="false"/>
		
	tiempoInmunidad1.maxLength=9;
	
	<pfs:numberfield name="tiempoInmunidad2" labelKey="plugin.recobroConfig.carteraEsquema.inmunidad.dos" 
		label="**Tiempo Inmunidad 2" value="${palanca.tiempoInmunidad2}" obligatory="false" allowNegative="false" allowDecimals="false"/>
		
	tiempoInmunidad2.maxLength=9;
	
	
	var validarForm= function(){
		if (filtroSubTipoPalanca.getValue()=='' || comboSiNo.getValue=='' || cmbPrioridad.getValue()==''){
			return false;
		}
		return true;
	};	

	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()){
    			var parms = {};
    			parms.idPalanca='${palanca.id}';
    			parms.idPolitica='${idPolitica}';
    			parms.codigoTipoPalanca=comboPalancas.getValue();
    			parms.codigoSubtipoPalanca=filtroSubTipoPalanca.getValue();
    			parms.codigoSiNo=comboSiNo.getValue();
    			parms.prioridad=cmbPrioridad.getValue();
    			parms.tiempoInmunidad1=tiempoInmunidad1.getValue();
    			parms.tiempoInmunidad2=tiempoInmunidad2.getValue();
 
    			page.webflow({
						flow: 'recobropoliticadeacuerdos/savePalancaPolitica'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,'<s:message code="plugin.recoveryConfig.altaAgencia.camposObligatorios" text="**Debe rellenar todos los campos obligatorios" />');
			}
		}
	});		
	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});
	
	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,autoWidth: true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true , autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [comboPalancas,filtroSubTipoPalanca,tiempoInmunidad1]}
						,{items: [comboSiNo,cmbPrioridad,tiempoInmunidad2]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	
	<%-- 
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_POLITICAS">
		btnGuardarValidacion.show();
	</sec:authorize>	
	--%>
	page.add(panelEdicion);
		
</fwk:page>		