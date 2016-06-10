<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<fwk:page>

	var codigoSubtipoEstandar = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo.SUBTIPO_ESTANDAR" />';

	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	
	var arrayCampos = new Array();
	
	var config = {width: 250, labelStyle:"width:150px;font-weight:bolder",allowBlank:false, forceSelection: true};
<%-- 	var idAsunto = '${asunto.id}'; --%>
	var idTermino = '${termino.id}';
	var idExpediente = '${idExpediente}';
	var contratosIncluidos = '${contratosIncluidos}';
	var soloConsulta = '${soloConsulta}';
	var idTipoAcuerdoPlanPago ='${idTipoAcuerdoPlanPago}';
	var yaHayPlanPago = '${yaHayPlanPago}';
	var fechaPaseMora = '${fechaPaseMora}';
	var ambito = '${ambito}';
	var idTipoAcuerdoFondosPropios ='${idTipoAcuerdoFondosPropios}';
	var idTipoAcuerdoRegulParcial = '${idTipoAcuerdoRegulParcial}';
	
	

    var tipoAcu = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		,{name:'codigo'}
		,{name:'esTipoCompraVentaDacion'}
	]);
	
	var optionsAcuerdosStore = page.getStore({
	       flow: 'mejacuerdo/getListTipoAcuerdosData'
	       ,params:{entidad:"${ambito}"} 
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoAcuerdos'
	    }, tipoAcu)	       
	});	

	var comboTipoAcuerdo = new Ext.form.ComboBox({
		store:optionsAcuerdosStore
		,id:'comboTipoAcuerdo'
		,allowBlank:false
		,displayField:'descripcion'
		,valueField:'id'
		,codigo: 'codigo'
		,mode: 'remote'
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.tipoTermino" text="**Solución Propuesta" />':'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.tipoAcuerdo" text="**Tipo termino" />'
		,labelStyle: 'width:150px'
		,width: 150		
	});
	
	optionsAcuerdosStore.webflow({entidad:"${ambito}"});
	
	comboTipoAcuerdo.on('select', function() {
	    creaCamposDynamics(this);
	    
    });
    
	var creaCamposDynamics = function (cmp) {
		if (cmp.getValue()!='' && cmp.getStore().getById(cmp.getValue()).data['esTipoCompraVentaDacion']) {
			bienesFieldSet.show();
			
		} else {
			bienesFieldSet.hide();
		}
	
	
      	page.webflow({
			flow: 'mejacuerdo/getCamposDinamicosTerminosPorTipoAcuerdo'
			,params:{idTipoAcuerdo:cmp.getValue()} 
			,success: function (result, request){
				detalleFieldSet.removeAll(true);
				
				var cmpLft = Ext.getCmp('dinamicElementsLeft');
			   	if (cmpLft && cmpLft.el) {
					cmpLft.el.remove();
			   	}
			   	
			  	var cmpRgt = Ext.getCmp('dinamicElementsRight');
			   	if (cmpRgt && cmpRgt.el) {
					cmpRgt.el.remove();
			   	}
				
				var camposDynamics = result;
		
				var dinamicElementsLeft = [];
				var dinamicElementsRight = [];
				
				for (var i = 0; i < camposDynamics.camposTerminoAcuerdo.length; i++) {
				    switch (camposDynamics.camposTerminoAcuerdo[i].tipoCampo) {
				    	case 'number':
				    		var campo = app.creaNumber(camposDynamics.camposTerminoAcuerdo[i].nombreCampo, camposDynamics.camposTerminoAcuerdo[i].labelCampo ,'', {id: camposDynamics.camposTerminoAcuerdo[i].nombreCampo, allowBlank:!camposDynamics.camposTerminoAcuerdo[i].obligatorio});
				    		break;
				    	case 'text':
				    		var campo = app.creaText(camposDynamics.camposTerminoAcuerdo[i].nombreCampo, camposDynamics.camposTerminoAcuerdo[i].labelCampo , '', {id: camposDynamics.camposTerminoAcuerdo[i].nombreCampo, allowBlank:!camposDynamics.camposTerminoAcuerdo[i].obligatorio});
				    		break;
				    	case 'fecha':
				    		var campo = new Ext.ux.form.XDateField({
											id: camposDynamics.camposTerminoAcuerdo[i].nombreCampo
											,name: camposDynamics.camposTerminoAcuerdo[i].nombreCampo
											,value : ''
											, allowBlank : !camposDynamics.camposTerminoAcuerdo[i].obligatorio
											,blankText: 'campo fecha obligatorio'
											,autoWidth:true
											 ,fieldLabel: camposDynamics.camposTerminoAcuerdo[i].labelCampo
										});
				    		break;
				    		
				    	case 'combobox':
				    		var campo = new Ext.form.ComboBox({
											id: camposDynamics.camposTerminoAcuerdo[i].nombreCampo,
											hiddenName : camposDynamics.camposTerminoAcuerdo[i].nombreCampo,
											fieldLabel: camposDynamics.camposTerminoAcuerdo[i].labelCampo,
										    triggerAction: 'all',
										    mode: 'local',
										    editable: false,
										    allowBlank : !camposDynamics.camposTerminoAcuerdo[i].obligatorio,
										    emptyText:'---',
										    store: new Ext.data.JsonStore({
										        fields: ['myId','displayText'],
										        data: camposDynamics.camposTerminoAcuerdo[i].valoresCombo
										    }),
										    valueField: 'myId',
										    displayField: 'displayText'
										});
										
				    		break;
				    	case 'html':
				    		var campo = new Ext.form.HtmlEditor({
											id: camposDynamics.camposTerminoAcuerdo[i].nombreCampo
											,name : camposDynamics.camposTerminoAcuerdo[i].nombreCampo
											,fieldLabel: camposDynamics.camposTerminoAcuerdo[i].labelCampo
											,readOnly:false
											,width: 580
											,height: 200
											,enableColors: true
									       	,enableAlignments: true
									       	,enableFont:true
									       	,enableFontSize:true
									       	,enableFormat:true
									       	,enableLinks:true
									       	,enableLists:true
									       	,enableSourceEdit:true		
											,html:''});	
				    		break;
				    		
				    }
				    
			    	if (i%2 == 0)
			    			dinamicElementsLeft.push(campo);
			    		else
			    			dinamicElementsRight.push(campo);	
			    						    
				}
				
				
				
				if (camposDynamics.camposTerminoAcuerdo.length>0) {
					detalleFieldSet.setVisible( true );
		    		detalleFieldSetContenedor.setVisible( true );
		    	} else {
					detalleFieldSet.setVisible( false );
		    		detalleFieldSetContenedor.setVisible( false );		    	
		    	}
		    	
		    	var dinamicElementsLeftSize = 400
		    	
		    	if(dinamicElementsRight.length < 1){
		    		dinamicElementsLeftSize = 800
		    	}
				var dinamicElementsLeft2 = {id:'dinamicElementsLeft', width:dinamicElementsLeftSize,items:dinamicElementsLeft};
				
		    	var dinamicElementsRight2 = {id:'dinamicElementsRight', width:400,items:dinamicElementsRight};

				detalleFieldSet.add([dinamicElementsLeft2,dinamicElementsRight2]);
				detalleFieldSet.doLayout();
				
	       		if("${operacionesPorTipo}"!=null && "${operacionesPorTipo}"!=''){
		       		<c:forEach var="operacion" items="${operacionesPorTipo}">
		       			if('${operacion.campo.tipoCampo}' == 'fecha'){
		       				var valorfecha = '${operacion.valor}';
		       				valorfecha = valorfecha.replace(/(\d*)-(\d*)-(\d*)/,"$3/$2/$1");
				    		Ext.getCmp('${operacion.campo.nombreCampo}').setValue(valorfecha);
				    	}else{
				    		Ext.getCmp('${operacion.campo.nombreCampo}').setValue('${operacion.valor}');
				    	}
				    	Ext.getCmp('${operacion.campo.nombreCampo}').setDisabled(false);
					</c:forEach>
		       	}
		       	
				if (Ext.getCmp('cargasPosterioresAnteriores')!=undefined) {
					var lblCargasPosterioresAnteriores = new Ext.form.Label({id:'lblCargasPosterioresAnteriores' ,text: '<s:message code="acuerdos.terminos.cargasPosteriores" text="**Debe introducir la informaci\u00F3n de cargas en la ficha del bien, pesta\u00F1a Cargas" />' ,hidden: true, style: labelStyle});
					Ext.getCmp('cargasPosterioresAnteriores').ownerCt.add(lblCargasPosterioresAnteriores);
					Ext.getCmp('cargasPosterioresAnteriores').ownerCt.doLayout();
					
					ocultarMostrarCamposCargas();
					Ext.getCmp('cargasPosterioresAnteriores').on ('select', function(record, index ) {
						ocultarMostrarCamposCargas();
					});
				}
				
				if (Ext.getCmp('otrosBienesSolvencia')!=undefined) {
					var lblBienesSolvencia = new Ext.form.Label({id:'lblBienesSolvencia' ,text: '<s:message code="acuerdos.terminos.otrosBienesSolvencia" text="**Debe introducir la informaci\u00F3n de bienes y solvencias en la ficha del cliente, pesta\u00F1a Solvencia" />' ,hidden: true, style: labelStyle});
					Ext.getCmp('otrosBienesSolvencia').ownerCt.add(lblBienesSolvencia);
					Ext.getCmp('otrosBienesSolvencia').ownerCt.doLayout();
				
					ocultarMostrarCamposSolvencia();
					Ext.getCmp('otrosBienesSolvencia').on ('select', function(record, index ) {
						ocultarMostrarCamposSolvencia();
					});
				}		
				
				if (Ext.getCmp('datosContacto1')!=undefined) {
					datosContacto1.maxLength = 9;
				}
				if (Ext.getCmp('datosContacto2')!=undefined) {
					datosContacto2.maxLength = 9;
				}
			}
			,error: function(){
			}       				
		});
	};
	
	var ocultarMostrarCamposCargas = function() {
		if (Ext.getCmp('cargasPosterioresAnteriores')!=undefined) {
			//Mostramos la label de aviso solo si su valor = 1
			if (Ext.getCmp('cargasPosterioresAnteriores').value != 1) {
				if(Ext.getCmp('lblCargasPosterioresAnteriores')!=undefined) Ext.getCmp('lblCargasPosterioresAnteriores').setVisible(false);
			} else {
				if(Ext.getCmp('lblCargasPosterioresAnteriores')!=undefined) Ext.getCmp('lblCargasPosterioresAnteriores').setVisible(true);			
			}
		}
	}
	
	var ocultarMostrarCamposSolvencia = function() {
		if (Ext.getCmp('otrosBienesSolvencia')!=undefined) {
			//Mostramos el resto de campos solo si su valor = 1
			if (Ext.getCmp('otrosBienesSolvencia').value != 1) {
				if(Ext.getCmp('lblBienesSolvencia')!=undefined) Ext.getCmp('lblBienesSolvencia').setVisible(false);
			} else {
				if(Ext.getCmp('lblBienesSolvencia')!=undefined) Ext.getCmp('lblBienesSolvencia').setVisible(true);
			}
		}	
	}
	
	var optionsSubtiposAcuerdosStore = page.getStore({
	       flow: 'mejacuerdo/getListSubTiposAcuerdosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoSubtiposAcuerdos'
	    }, tipoAcu)	       
	});	
	
	var comboSubTipoAcuerdo = new Ext.form.ComboBox({
		store:optionsSubtiposAcuerdosStore
		,displayField:'descripcion'
		,valueField:'id'
		,autoSelect: true
		,mode: 'local'
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: (ambito!='asunto') ? '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.subtipoTermino" text="**Subtipo Solución Propuesta" />' :'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.subtipoAcuerdo" text="**Subtipo termino" />'
		,labelStyle: 'width:150px'
		,width: 150				
	});

	var informeLetrado = new Ext.form.HtmlEditor({
		id:'note'
		,readOnly:false
		,width: 600
		,height: 200
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true		
		,html:''});		
	
	var tipoPro = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	<%-- var optionsTipoProductoStore = page.getStore({
	       flow: 'mejacuerdo/getListTipoProductosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoProductos'
	    }, tipoPro)	       
	});	--%>
	
	<%--var comboTipoProducto = new Ext.form.ComboBox({
		store:optionsTipoProductoStore
        ,displayField:'descripcion'
        ,allowBlank:false
		,valueField:'id'
		,mode: 'remote'
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.producto" text="**Producto" />'
		,labelStyle: 'width:150px'
		,width: 170					
	});--%>
	
	
	var flujoFieldSet = new Ext.FormPanel({
		autoWidth: true
		,autoHeight: true
		,style:'padding:0px'
  	   	,border:false
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
		 	{items:[comboTipoAcuerdo,comboSubTipoAcuerdo],width:450}
		 	<%-- ,{items:[comboTipoProducto],width:450}--%>
		]
	});	
	
	var flujoFieldSetContenedor = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.flujo.titulo" text="**Flujo por solución"/>' 
		,border:true
		,items: [flujoFieldSet]
	});	
	
	var detalleFieldSet = new Ext.FormPanel({
		id:'dynamicForm'
		,autoHeight: false
		,autoWidth: true
		,hidden:true
		,border:false
		,style:'padding:0px'
		,layout:'column'
		,layoutConfig:{columns:2}	
		,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'}
	});	
	
	var detalleFieldSetContenedor = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.detalles.titulo" text="**Detalle operaciones"/>' 
		,hidden:true
		,items: [detalleFieldSet]
	});	
	
	var informeFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.informe" text="**Observaciones"/>'
		,layout:'form'
		,autoHeight:true
		,autoWidth: true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
			{items:[informeLetrado]}
		]
	});		
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
		
						page.fireEvent(app.event.CANCEL);  	
					}
	});	

	var btnGuardar = new Ext.Button({	
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
       		var formulario = flujoFieldSet.getForm();
       		var fechaActual = new Date();
       		
       		fechaActual.setHours(0);
			fechaActual.setMinutes(0);
			fechaActual.setSeconds(0);
			
			fechaActual = Date.parse(fechaActual);
       		if(formulario.isValid() && detalleFieldSet.getForm().isValid()){
       			var dateSolucionPrevista = null;
       			if (Ext.getCmp('fechaSolucionPrevista')!=undefined) {
       				dateSolucionPrevista = Date.parse(Ext.getCmp('fechaSolucionPrevista').getValue());
       			}
       			
       			if(dateSolucionPrevista != null && !isNaN(parseFloat(dateSolucionPrevista)) && Ext.getCmp('fechaSolucionPrevista').getValue() < fechaActual){
       				Ext.Msg.show({
				   		title:'Aviso',
				   		msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.aviso.fechaActual" text="**Fecha solicitud prevista no puede ser menor a la actual." />',
				   		buttons: Ext.Msg.OK
					});
					
					return false;
       			}
       			
       			<%--
       			if (Ext.getCmp('cargasPosterioresAnteriores')!=undefined) {
       				if (Ext.getCmp('cargasPosterioresAnteriores').value==1) {
       					//Poner aqu� la comprobaci�n si tiene Cargas en la pesta�a Cargas del Bien
       					if (valoracionCargas.value=='' || descripcionCargas.value=='') {
       						Ext.Msg.show({
       							title:'Aviso',
       							msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.camposCargas.obligatorios" text="**Debe rellenar la informaci�n para la Carga" />',
       							buttons: Ext.Msg.OK
       						});
       						return false;
       					}
       				}
       			}
       			 --%>
       			
       			<%--
				if (Ext.getCmp('otrosBienesSolvencia')!=undefined) {
					if (Ext.getCmp('otrosBienesSolvencia').value==1) {
						//Poner aqu� la comprobaci�n si tiene Otros Bienes/Solvencia en la pesta�a correspondiente del cliente
						if (valoracionBienesSolvencia.value=='' || descripcionBienesSolvencia.value=='') {
      						Ext.Msg.show({
       							title:'Aviso',
       							msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.camposSolvencia.obligatorios" text="**Debe rellenar la informaci�n para Otros Bienes/Solvencia" />',
       							buttons: Ext.Msg.OK
       						});
       						return false;						
						}
					}
				}
				--%>   			
       			
       			<%--if(dateSolucionPrevista!=null &&  dateSolucionPrevista > fechaPaseMora && ambito!='asunto' ) {
       				var date = new Date(parseFloat(fechaPaseMora));
       				date = Ext.util.Format.date(date, "d/m/y");
	       			Ext.Msg.show({
				   		title:'Aviso',
				   		msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.aviso.fondosPropios" text="**Fecha solicitud prevista debe ser menor a la fecha de pase a mora " /> (' + date + ').',
				   		buttons: Ext.Msg.OK
					});
					return false;
	       		}  --%>
	       		if(comboTipoAcuerdo.getValue()==idTipoAcuerdoFondosPropios && isNaN(parseFloat(dateSolucionPrevista))) {
	       			return false;
	       		}else if(comboTipoAcuerdo.getValue() == idTipoAcuerdoRegulParcial && isNaN(parseFloat(dateSolucionPrevista))){
	       			Ext.Msg.show({
				   		title:'Aviso',
				   		msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.aviso.regulParcial" text="**La Fecha solicitud prevista es obligatoria." />',
				   		buttons: Ext.Msg.OK
					});
	       		}else if (yaHayPlanPago=='true' && comboTipoAcuerdo.getValue()==idTipoAcuerdoPlanPago){
	        		Ext.Msg.show({
				   		title:'Aviso',
				   		msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.aviso.planPago" text="**Este acuerdo ya tiene asignado un Plan de Pago" />',
				   		buttons: Ext.Msg.OK
					});       			
       			}else if (comboBienes.getValue()== '' && bienesFieldSet.isVisible()){
       				Ext.Msg.show({
				   		title:'Aviso',
				   		msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.aviso.bienesPropuesta" text="**Rellene el campo Bienes del asunto" />',
				   		buttons: Ext.Msg.OK
					});
       				
       			}
       			else {
       		
	       		var params = detalleFieldSet.getForm().getValues();
	       		
	       		
	       		Ext.apply(params, {idAcuerdo : '${idAcuerdo}' });
	       		Ext.apply(params, {idTipoAcuerdo : comboTipoAcuerdo.getValue()});
	       		Ext.apply(params, {idSubTipoAcuerdo : comboSubTipoAcuerdo.getValue()});
	       		<%--Ext.apply(params, {idTipoProducto : comboTipoProducto.getValue()});--%>
	       		
	       		Ext.apply(params, {informeLetrado : informeLetrado.getValue()});
	       		Ext.apply(params, {contratosIncluidos : '${contratosIncluidos}'});
	       		Ext.apply(params, {bienesIncluidos : comboBienes.getValue()});     		
	       		Ext.apply(params, {idTermino : idTermino });     		
	       		
	       		Ext.Ajax.request({
					url: page.resolveUrl('mejacuerdo/crearTerminoAcuerdo')
					,method: 'POST'
					,params:params 
					,success: function (result, request){
						 Ext.MessageBox.show({
				            title: 'Guardado',
				            msg: '<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.mensajeGuardadoOK" text="**GuardadoCorrecto" />',
				            width:300,
				            buttons: Ext.MessageBox.OK
				        });
						page.fireEvent(app.event.DONE);
					}
					,error: function(){
						Ext.MessageBox.show({
				           title: 'Guardado',
				           msg: '<s:message code="plugin.mejoras.asunto.ErrorGuardado" text="**Error guardado" />',
				           width:300,
				           buttons: Ext.MessageBox.OK
				       });
						page.fireEvent(app.event.CANCEL);
					}       				
				});	
			}
			}
			else{
				Ext.MessageBox.show({
				           title: 'Error',
				           msg: 'Por favor rellene los campos obligatorios',
				           width:300,
				           buttons: Ext.MessageBox.OK
				       });
			}	
       		
     	}		
	});
	
	var bienesRecord = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
	]);	
	
 <%--
   var bienesStore = page.getStore({
		eventName : 'listado'
		,flow:'mejacuerdo/obtenerListadoBienesAcuerdoByAsuId'
		,reader: new Ext.data.JsonReader({
	        root: 'bienes'
		}, bienesRecord)
	});	
			
	bienesStore.webflow({idAsunto:idAsunto});
 --%>	

	if("${esPropuesta}" == "true"){
			
		var bienesStore = page.getStore({
			eventName : 'listado'
			,flow:'propuestas/obtenerListadoBienesPropuesta'
			,reader: new Ext.data.JsonReader({
		        root: 'bienes'
			}, bienesRecord)
		});
				
	}else{
		
		var bienesStore = page.getStore({
			eventName : 'listado'
			,flow:'mejacuerdo/obtenerListadoBienesContratosAcuerdo'
			,reader: new Ext.data.JsonReader({
		        root: 'bienes'
			}, bienesRecord)
		});	
	}

	if("${termino}"!=null && "${termino}"!=''){
		bienesStore.on('load', function() {
	       	if("${termino.bienes}"!=null && "${termino.bienes}"!=''){
	        	<c:forEach var="bien" items="${termino.bienes}">
			    	comboBienes.setValue("${bien.bien.id}"); 
				</c:forEach>
		    }
		});
	}			


	if("${esPropuesta}" == "true"){
		bienesStore.webflow({idExpediente:idExpediente, contratosIncluidos:contratosIncluidos});
	}else {
		bienesStore.webflow({idTermino:idTermino, contratosIncluidos:contratosIncluidos});
	}

				
	config.store = bienesStore;	
	
	var comboBienes = app.creaDblSelect(null,'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.combo" text="**Bienes del asunto/Bienes para dación" />',config); 
	
	

	var bienesFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="plugin.mejoras.acuerdos.tabTerminos.terminos.terminos.agregar.bienes.titulo" text="**Bienes de la propuesta y garantías seleccionadas"/>'
		,layout:'form'
		,autoWidth: true
		,autoHeight: true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,items : [
		 	comboBienes
		]		
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,hidden: true
	});	                                            	

   var panelAltaTermino=new Ext.Panel({
		layout:'form'
		,border : false
		,bodyStyle:'padding:2px;margin:2px'
		,width: 700
		,height: 400
		,autoScroll: true
		,nombreTab : 'altaTermino'
		,items : [flujoFieldSetContenedor, bienesFieldSet, detalleFieldSetContenedor, informeFieldSet]
		<c:choose>
		    <c:when test="${termino != null && termino != ''}">
		       <c:if test="${soloConsulta == 'true'}">
		       		,bbar : [btnCancelar]
		       </c:if>
		       <c:if test="${soloConsulta != 'true'}">
		       		,bbar : [btnGuardar, btnCancelar]
		       </c:if>		       
		    </c:when>
		    <c:otherwise>
				,bbar : [btnGuardar,btnCancelar]
		    </c:otherwise>
		</c:choose>
				
	});	
	
	Ext.onReady(function () {
		<%-- Modo Visualizacion --%>
		if("${termino}"!=null && "${termino}"!=''){
			
			
			if("${termino.tipoAcuerdo.id}"!=null && "${termino.tipoAcuerdo.id}"!=''){
				comboTipoAcuerdo.store.load();
		    	comboTipoAcuerdo.store.on('load', function(){  
		        	comboTipoAcuerdo.setValue(${termino.tipoAcuerdo.id});
		        	creaCamposDynamics(comboTipoAcuerdo);
		        	
		       	});
		       	
		       	
	       	}
	       	
	       	if("${termino.subtipoAcuerdo.id}"!=null && "${termino.subtipoAcuerdo.id}"!=''){
		       	comboSubTipoAcuerdo.store.load();
		    	comboSubTipoAcuerdo.store.on('load', function(){  
		        	comboSubTipoAcuerdo.setValue(${termino.subtipoAcuerdo.id});
		       	});
	       	}
	       	
	       	var informLetrado = '<s:message text="${termino.informeLetrado}" javaScriptEscape="true" />';
	       	
	       	if(informLetrado !=null && informLetrado !=''){
	       		informeLetrado.setValue(informLetrado);
	       	}
	       	
	       	comboTipoAcuerdo.setDisabled(false);
	       	comboSubTipoAcuerdo.setDisabled(false);
	       	<%--comboTipoProducto.setDisabled(false);--%>
	       	comboBienes.setDisabled(false);
	       	informeLetrado.setDisabled(false);	       	
	       	
	       	<%--if("${termino.tipoProducto.id}"!=null && "${termino.tipoProducto.id}"!=''){
	       		comboTipoProducto.store.load();
		    	comboTipoProducto.store.on('load', function(){  
		        	comboTipoProducto.setValue(${termino.tipoProducto.id});
		       	});
	       	}--%>
	       	
	       	
		} else {
			//Valor por defecto para SubTipoAcuerdo
	       	comboSubTipoAcuerdo.store.load();
	    	comboSubTipoAcuerdo.store.on('load', function(){ 
	        	
				var index = comboSubTipoAcuerdo.store.findBy(function (record) {
   					return record.data.codigo == codigoSubtipoEstandar;
				});
				comboSubTipoAcuerdo.setValue(comboSubTipoAcuerdo.store.getAt(index).id);	        	
	       	});			
		}
	});
		

	page.add(panelAltaTermino);


</fwk:page>  