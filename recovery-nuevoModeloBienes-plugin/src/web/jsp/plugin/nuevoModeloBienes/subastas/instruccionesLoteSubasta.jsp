<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	var maxWidth = 1170;
	var labelStyle='width:140';
	var labelStyleShort='width:90';
	
	var idLote = new Ext.form.Hidden({name:'idLote', value :'${instrucciones.id}'}) ;

	var idLoteP = app.creaText("idLoteP", '<s:message code="subastas.instruccionesLoteSubasta.idlote" text="**Id. Lote"/>','${instrucciones.id}',{width:80,maxLength:16,labelStyle:labelStyleShort});
	var numeroLote = app.creaText("numeroLote", '<s:message code="subastas.instruccionesLoteSubasta.lote" text="**Lote"/>','${instrucciones.numLote}',{width:80,maxLength:16,labelStyle:labelStyleShort});		
	var txtPujaSinPostores = app.creaMoneda("pujaSinPostores", '<s:message code="subastas.instruccionesLoteSubasta.pujaSinPostores" text="**Puja sin postores"/>','${instrucciones.insPujaSinPostores}',{width:80,maxLength:16,labelStyle:labelStyle });
	var mmPujaConPostores = app.creaMinMaxMoneda('<s:message code="subastas.instruccionesLoteSubasta.pujaConPostores" text="**Puja con postores" />', 'pujaConPostores',{width : 80,labelWidth:142});
	mmPujaConPostores.min.setValue('${instrucciones.insPujaPostoresDesde}');
	mmPujaConPostores.max.setValue('${instrucciones.insPujaPostoresHasta}');
	var txtValorSubasta = app.creaMoneda("valorSubasta", '<s:message code="subastas.instruccionesLoteSubasta.valorSubasta" text="**Valor de la subasta"/>','${instrucciones.insValorSubasta}',{width:80,maxLength:16,labelStyle:labelStyle});
	var txt50delTipoSub = app.creaMoneda("50delTipo", '<s:message code="subastas.instruccionesLoteSubasta.50delTipo" text="**50% del tipo de subasta"/>','${instrucciones.ins50DelTipoSubasta}',{width:80,maxLength:16,labelStyle:labelStyle});
	var txt60delTipoSub = app.creaMoneda("60delTipo", '<s:message code="subastas.instruccionesLoteSubasta.60delTipo" text="**60% del tipo de subasta"/>','${instrucciones.ins60DelTipoSubasta}',{width:80,maxLength:16,labelStyle:labelStyle});
	var txt70delTipoSub = app.creaMoneda("70delTipo", '<s:message code="subastas.instruccionesLoteSubasta.70delTipo" text="**70% del tipo de subasta"/>','${instrucciones.ins70DelTipoSubasta}',{width:80,maxLength:16,labelStyle:labelStyle});
	var txtDeudaJudicial = app.creaMoneda("deudaJudicial", '<s:message code="subastas.instruccionesLoteSubasta.deudaJudicial" text="**Deuda Judicial"/>','${instrucciones.deudaJudicial}',{width:80,maxLength:16,labelStyle:labelStyleShort});
	var txtEstadoLote = app.creaText("estadoLote", '<s:message code="subastas.instruccionesLoteSubasta.estadoLote" text="**Estado"/>','${instrucciones.estado.descripcion}',{width:80,maxLength:16,labelStyle:labelStyleShort});
	var txtFechaEstado = app.creaText("fechaEstado", '<s:message code="subastas.instruccionesLoteSubasta.fechaEstado" text="**Fecha Estado"/>'
		,'<fmt:formatDate value="${instrucciones.fechaEstado}" pattern="dd/mm/yyyy"/>'
		,{width:80
			,maxLength:16
			,labelStyle:labelStyleShort
		});
		
	var diccionarioRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'descripcion'}
	]);
	var sinoStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'sinoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	sinoStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo' });

	var cmbRiesgoConsigna = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'lote.riesgoConsigna'
			,fieldLabel:'<s:message code="subastas.instruccionesLoteSubasta.riesgoConsignacion" text="**Riesgo Consignación"/>'
			,value : '${instrucciones.riesgoConsignacion}' == '' ? '' : '${instrucciones.riesgoConsignacion}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyleShort
			,width:100
	});
		
	var panelCampos = new Ext.form.FieldSet({		
		autoHeight : true
	    ,autoWidth : false
	    ,width: maxWidth-20
        ,collapsed: false
        ,layout:'table'
        ,layoutConfig:{
				columns:4
			}
		,defaults : {xtype : 'fieldset', autoHeight : false, border : false ,cellCls : 'vtop', height: 130, width:440}
		,items : [{width: 270,items:[idLoteP, numeroLote]},
				  {width: 340,items:[txtPujaSinPostores,mmPujaConPostores.panel,txtValorSubasta]},
				  {width: 270,items:[txt50delTipoSub,txt60delTipoSub,txt70delTipoSub]},
				  {width: 270,items:[cmbRiesgoConsigna,txtDeudaJudicial,txtEstadoLote,txtFechaEstado]}
				 ]
	});

	var lObservaciones = app.creaLabel('<s:message code="subastas.instruccionesLoteSubasta.panelCampos.observaciones" text="**Observaciones" />');
	
	var observaciones = new Ext.form.HtmlEditor({
		fieldLabel : ''
    	,hideLabel:true
		,enableColors: false
       	,enableFont:false
       	,enableFontSize:false
       	,enableFormat:true
       	,enableAlignments: false
       	,enableLinks: false
       	,enableLists:false
       	,enableSourceEdit:false
    	,labelSeparator:''
    	,width: 1150
    	,height: 100
    	,value:'<s:message text="${instrucciones.observaciones}" javaScriptEscape="true" />'
	});

	<c:if test="${not empty instrucciones.observacionesComite}">
	var observacionesComite = new Ext.form.TextArea({
		fieldLabel:'<s:message code="subastas.instruccionesLoteSubasta.observacionesComite" text="**Observaciones Comité" />'
		,width:500
		,readOnly:true
		,labelStyle:labelStyle
		,value:'${instrucciones.observacionesComite}'
		,name:'observacionesComite'
	});	
	</c:if>
	
	var panelInterior = new Ext.FormPanel({	
	    bodyStyle:'margin:10px;'
	    ,autoHeight : true
	    ,autoWidth : false
	    ,width: maxWidth-10
	    ,border: false
	    ,items:[panelCampos
		<c:if test="${not empty instrucciones.observacionesComite}">
	    ,observacionesComite
		</c:if>
	    ,lObservaciones,observaciones]
	});
	
	var getParams = function(){
		return {
			idLote:idLote.getValue(),
			pujaSinPostores:txtPujaSinPostores.getValue(),
			pujaPostoresDesde: mmPujaConPostores.min.getValue(),
			pujaPostoresHasta: mmPujaConPostores.max.getValue(),
			valorSubasta: txtValorSubasta.getValue(),
			tipoSubasta50: txt50delTipoSub.getValue(),
			tipoSubasta60: txt60delTipoSub.getValue(),
			tipoSubasta70: txt70delTipoSub.getValue(),
			observaciones: observaciones.getValue(),
			riesgoConsignacion: cmbRiesgoConsigna.getValue(),
			deudaJudicial: txtDeudaJudicial.getValue()
		}	
	};
	
	var btnAceptar = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
		   ,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	       		if(validarForm()){
	      			page.webflow({
		      			flow:'subasta/guardarInstruccionesLote'
		      			,params: getParams()
		      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            		}	
		      		});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios" code="subastas.instruccionesLoteSubasta.camposObligatorios"/>');
				}
	     	}
	});
		
	var validarForm = function() {
		if(cmbRiesgoConsigna.getValue() == null || cmbRiesgoConsigna.getValue()== '' ){
			return false;
		} else if (txtDeudaJudicial.getValue() == null || txtDeudaJudicial.getValue()== '' ){
			return false;
		}
		return true;
	}
		
	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});

	var panel = new Ext.Panel({	
	    autoHeight : true
	    //height: 320
	    ,autoWidth : false
	    ,width: maxWidth
	    ,border: false
	    ,items:[panelInterior]
	    ,bbar : [btnAceptar, btnCancelar]	    
	});
	

	page.add(panel);
	
	idLoteP.setDisabled(true);
	numeroLote.setDisabled(true);
	txt50delTipoSub.setDisabled(true);
	txt60delTipoSub.setDisabled(true); 
	txt70delTipoSub.setDisabled(true);
	txtEstadoLote.setDisabled(true);
	txtFechaEstado.setDisabled(true);

</fwk:page>
