<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>


<fwk:page>

	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	
	var idBienes=new Array();
	<c:forEach var="id" items="${idBienes}"> 
		    idBienes.push(<c:out value="${id}"/>);
	</c:forEach>
	
	
	<%-- AGREGAR CARGAS --%>
	
	var tipoCarga = app.creaCombo({
			data : <app:dict value="${tipoCarga}" />
			<app:test id="tipoCarga" addComa="true" />
			,name : 'tipoCarga'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.cargas.tipoCarga" text="**Tipo Carga" />'
			,labelStyle: labelStyle
			,width: 150
			,allowBlank: false			
		});
    // Fechas
    
	var fechaPresentacion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.fechaPresentacion" text="**fechaRevision" />'
			,labelStyle: labelStyle
			,name:'carga.fechaPresentacion'
			,value:	'<fwk:date value="${Carga.fechaPresentacion}"/>'
			,style:'margin:0px'		
	});
	
	var fechaInscripcion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.fechaInscripcion" text="**fechaInscripcion" />'
			,labelStyle: labelStyle
			,name:'carga.fechaInscripcion'
			,value:	'<fwk:date value="${Carga.fechaInscripcion}"/>'
			,style:'margin:0px'		
	});	
	
	var fechaCancelacion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.fechaCancelacion" text="**fechaCancelacion" />'
			,labelStyle: labelStyle
			,name:'carga.fechaCancelacion'
			,value:	'<fwk:date value="${Carga.fechaCancelacion}"/>'
			,style:'margin:0px'		
	});	
	
		    // Booleanos
    
	var registral = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.registral" text="**registral"/>'
		,name:'registral'
		,labelStyle:labelStyle
		,disabled: false
        ,listeners: {
            check: function(checkbox, checked) {
                    if(checked){
                            situacionCarga.allowBlank = false;
                            situacionCarga.validate();
                    } else {
                            situacionCarga.allowBlank = true;
                            situacionCarga.validate();
                    }
            }
        }
	});
	
	if('${Carga.registral}' == 'true'){
		registral.checked = true;
	}
	else{
		registral.checked = false;
	}
	
	var economica = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.economica" text="**economica"/>'
		,name:'economica'
		,labelStyle:labelStyle
		,disabled: false
        ,listeners: {
           check: function(checkbox, checked) {
                   if(checked){
                           situacionCargaEconomica.allowBlank = false;
                           situacionCargaEconomica.validate();
                   } else {
                           situacionCargaEconomica.allowBlank = true;
                           situacionCargaEconomica.validate();
                   }
           }
       }
	});
	
	if('${Carga.economica}' == 'true'){
		economica.checked = true;
	}
	else{
		economica.checked = false;
	}	
	
	// Textos
	var  letra = app.creaText('letra','<s:message code="plugin.nuevoModeloBienes.cargas.letra" text="**letra"/>','${Carga.letra}', {labelStyle:labelStyle});
	var  titular = app.creaText('titular','<s:message code="plugin.nuevoModeloBienes.cargas.titular" text="**titular"/>','${Carga.titular}', {labelStyle:labelStyle});
	
	// Importes
	var importeRegistral = app.creaNumber('importeRegistral', '<s:message code="plugin.nuevoModeloBienes.cargas.importeRegistral" text="**importeRegistral" />', '${Carga.importeRegistral}' , {labelStyle:labelStyle});
	var importeEconomico = app.creaNumber('importeEconomico', '<s:message code="plugin.nuevoModeloBienes.cargas.importeEconomico" text="**importeEconomico" />', '${Carga.importeEconomico}', {labelStyle:labelStyle});

	//DICCIONARIOS
	var situacionCarga = app.creaCombo({
			data : <app:dict value="${situacionCarga}" />
			<app:test id="situacionCarga" addComa="true" />
			,name : 'situacionCarga'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.cargas.situacionCarga" text="**situacionCarga" />'
			,value : '${Carga.situacionCarga.codigo}'
			,labelStyle: labelStyle
			,width: 150
			//,allowBlank: false			
		});
		
	var situacionCargaEconomica = app.creaCombo({
			data : <app:dict value="${situacionCargaEconomica}" />
			<app:test id="situacionCargaEconomica" addComa="true" />
			,name : 'situacionCargaEconomica'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.cargas.situacionCargaEconomica" text="**situacionCargaEconomica" />'
			,value : '${Carga.situacionCargaEconomica.codigo}'
			,labelStyle: labelStyle
			,width: 150
			//,allowBlank: false			
		});	
		
	var validateForm = function(){
		if(tipoCarga.getValue() == ''){
                 Ext.MessageBox.alert('<s:message code="plugin.nuevoModeloBienes.cargas.validar.warning" text="**Aviso" />'
                 ,'<s:message code="plugin.nuevoModeloBienes.cargas.validar.msgTipoCarga" text="**Debe seleccionar un valor de Tipo Carga" />');
                 return false;
        }
	  	if(situacionCarga.getValue() == '' && registral.checked == true){
                 Ext.MessageBox.alert('<s:message code="plugin.nuevoModeloBienes.cargas.validar.warning" text="**Aviso" />'
                 ,'<s:message code="plugin.nuevoModeloBienes.cargas.validar.msgSituacionCarga" text="**Seleccionar una Situacion de Carga Registral" />');
                 return false;
        }
               
		return true;
	}	

	var getParametros = function() {
	 	var parametros = {};
	 	parametros.idBienes=idBienes;
	 	parametros.tipoCarga = tipoCarga.getValue();
		parametros.fechaPresentacion = fechaPresentacion.getValue() ? fechaPresentacion.getValue().format('d/m/Y') : '';
		parametros.fechaInscripcion = fechaInscripcion.getValue() ? fechaInscripcion.getValue().format('d/m/Y') : '';
		parametros.fechaCancelacion = fechaCancelacion.getValue() ? fechaCancelacion.getValue().format('d/m/Y') : '';
		parametros.registral = registral.getValue();
		parametros.economica = economica.getValue();
		parametros.letra = letra.getValue();		
		parametros.titular = titular.getValue();		
		parametros.importeRegistral = importeRegistral.getValue();
		parametros.importeEconomico = importeEconomico.getValue();
		parametros.situacionCarga = situacionCarga.getValue();
		parametros.situacionCargaEconomica = situacionCargaEconomica.getValue();
	 
	 	return parametros;
	 }	
	 
	
		var btnEditar = new Ext.Button({
		    text: '<s:message code="app.guardar" text="**Guardar" />'
			<app:test id="btnGuardarCarga" addComa="true" />
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
				if (validateForm()) {	
			    	var p = getParametros();
			    	Ext.Ajax.request({
							url : page.resolveUrl('subasta/saveCargaMultiple'), 
							params : p,
							method: 'POST',
							success: function ( result, request ) {
								page.fireEvent(app.event.DONE);
							}
					});
				}
	        }
		});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
		
	var panelAgregarCargas = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.cargas.agregar.titulo" text="**Datos carga"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[tipoCarga,fechaPresentacion,fechaInscripcion,fechaCancelacion,registral,economica]}
	    		  ,{items:[letra,titular,importeRegistral,importeEconomico,situacionCarga,situacionCargaEconomica]}]
	});	
	
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		autoScroll:true
		,width:775
		,autoHeight:true
		//,autoWidth : true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items : [panelAgregarCargas]
		,nombreTab : 'agregarCargas'
		,bbar:new Ext.Toolbar()
	});
	
	//<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		panel.getBottomToolbar().addButton([btnEditar]);
	//</sec:authorize>
	
	panel.getBottomToolbar().addButton([btnCancelar]);
		
	page.add(panel);	
	
	
</fwk:page>
