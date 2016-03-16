<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var idContratoObjetivo = null;
	var recordContratoSeleccionado = null;

	var labelStyle = 'font-weight:bolder;width:100px';
	var cfg = {labelStyle:"width:400;font-weight:bolder",width:400};
	

	var riesgoDirecto=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirecto" text="**riesgoDirecto" />',app.format.moneyRenderer('${persona.riesgoTotal}') , {},cfg);
	var riesgoIndirecto=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoIndirecto" text="**riesgoIndirecto" />',app.format.moneyRenderer('${persona.riesgoIndirecto}') , {},cfg);
	var riesgoIrregular=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.riesgoIrregular" text="**riesgoIrregular" />',app.format.moneyRenderer('${persona.riesgoDirectoDanyado}') , {},cfg);
	var riesgoGarantizado=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.riesgoGarantizado" text="**riesgoGarantizado" />',app.format.moneyRenderer('${persona.riesgoGarantizadoPersona}') , {},cfg);
	var riesgoNoGantizado=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.riesgoNoGarantizado" text="**riesgoNoGantizado" />',app.format.moneyRenderer('${persona.riesgoNoGarantizadoPersona}') , {},cfg);
	

	var fieldSetPersona = new Ext.form.FieldSet({
			autoHeight:true
			,width:850
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="editar.objetivo.datosPersona" text="**Datos Principales"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:400}
		    ,items : [{items:[riesgoDirecto,riesgoIndirecto,riesgoIrregular]},
					  {items:[riesgoGarantizado,riesgoNoGantizado]}
					 ]
		});






	var isObjetivoAutomatico = null;

	<c:if test="${justificarObjetivo!=null && justificarObjetivo}">
		var justificacion = new Ext.form.TextArea({
			fieldLabel: '<s:message code="editar.objetivo.justificacion" text="**Justificación" />'
			,value: '<s:message javaScriptEscape="true" text="${objetivo.justificacion}" />'
			,labelStyle: labelStyle
			,style: 'font-weight:bolder;margin-bottom:10px;'
			,width: 740
			,height: 50
			,maxLength: 250
			,labelStyle: labelStyle
			//,readOnly: true
		});
	</c:if>

	var operadorCombo = app.creaCombo({
		data: <app:dict value="${tiposOperador}" />
		,fieldLabel: '<s:message code="editar.objetivo.operador" text="**Operador" />'
		,value: '${objetivo.tipoOperador.codigo}'
		,labelStyle: labelStyle
		<c:if test="${readOnly}">
			,disabled: true
		</c:if>
	});

	// Creamos el JSON de objetivos sin el tag 'dict' porque necesitamos el valor del campo 'automatico'
	<c:set var="blankElement" value="true" />
	var objetivos = <json:object>
		<json:array name="diccionario" items="${tiposObjetivo}" var="d">	
			 <c:if test="${blankElement}">
		 	 		<json:object>
			 			<json:property name="codigo" value=""/>
				 		<json:property name="descripcion" value="---" />
				 		<json:property name="automatico" value="" />
			 		</json:object>
			 		<c:set var="blankElement" value="false"/>
			 </c:if>
		 <json:object>
		   <json:property name="codigo" value="${d.codigo}" />
		   <json:property name="descripcion" value="${d.descripcion}" />
		   <json:property name="automatico" value="${d.automatico}" />
		   <json:property name="contrato" value="${d.contrato}" />
		 </json:object>
		</json:array>
	</json:object>;

	// Retorna si el tipo de objetivo seleccionado es automático
	var isAutomatico = function(codigo) {
		var i=0;
		if(objetivos.diccionario.length!=0){
			while(!(objetivos.diccionario[i].codigo==codigo)) { i++; };
			return objetivos.diccionario[i].automatico;
		}
	};

	// Retorna true si el tipo de objetivo seleccionado es automático de tipo persona (contrato = false)
	var isTipoPersona = function(codigo) {
		var i=0;
		if(objetivos.diccionario.length!=0){
			while(!(objetivos.diccionario[i].codigo==codigo)) { i++; };
			if(!objetivos.diccionario[i].automatico) {
				return false;
			}
			return !objetivos.diccionario[i].contrato;
		}
	};

	isObjetivoAutomatico = isAutomatico('${objetivo.tipoObjetivo.codigo}');

	var getCodContratoSeleccionado = function() {
		if(idContratoObjetivo == null) {
			return null;
		}
		var i=0;
		while(contratos.contratos[i].id!=idContratoObjetivo) { i++; };
		return contratos.contratos[i].cc;
	};

	var isPrimerLlamada = true;
	var tipoObjetivoHandler = function() {
		if(!isAutomatico(tipoObjetivoCombo.getValue())) {	// Si es manual
			resumenObjetivo.enable();
			isObjetivoAutomatico = false;
			operadorCombo.disable();
			operadorCombo.setValue('');
			cantLimiteNumber.disable();
			cantLimiteNumber.setValue('');
			if(!isPrimerLlamada) {
				resumenObjetivo.setValue('');
			} else {
				isPrimerLlamada = false;
			}
			fechaLimite.un('change', parseResumen);
			contratosGrid.disable();
		} else {											// Si es automático
			resumenObjetivo.enable();
			//resumenObjetivo.readOnly = false;
			isObjetivoAutomatico = true;
			operadorCombo.enable();
			cantLimiteNumber.enable();
			fechaLimite.on('change', parseResumen);
			if(!isTipoPersona(tipoObjetivoCombo.getValue())) {
				contratosGrid.enable();
			} else {
				contratosGrid.disable();
			}
			resumenObjetivo.disabled = true;
			if(!isPrimerLlamada) {
				parseResumen();
			} else {
				isPrimerLlamada = false;
			}
			//resumenObjetivo.readOnly = true;
			resumenObjetivo.disable();
		}
	};

	var tipoObjetivoCombo = app.creaCombo({
		data: objetivos
		,fieldLabel: '<s:message code="editar.objetivo.tipoObjetivo" text="**Tipo de objetivo" />'
		,value: '${objetivo.tipoObjetivo.codigo}'
		,labelStyle:labelStyle
		<c:if test="${readOnly}">
			,disabled: true
		</c:if>
	});

	tipoObjetivoCombo.on('select', tipoObjetivoHandler);

	var fechaLimite = new Ext.ux.form.XDateField({
		fieldLabel: '<s:message code="editar.objetivo.fechaLimite" text="**Fecha límite" />'
		,name:'fechaLimite'
		,labelStyle: labelStyle
		,style:'margin:0px'
		,value: '<fwk:date value="${objetivo.fechaLimite}" />'
        ,minValue: new Date()
		<c:if test="${readOnly}">
			//,disabled: true
		</c:if>
	  });

	var cantLimiteNumber  = app.creaNumber('valor',
		'<s:message code="editar.objetivo.limite" text="**Cant. limite" />',
		'${objetivo.valor}',{labelStyle:labelStyle,allowDecimals:true,allowNegative:false<c:if test="${readOnly}">,disabled: true</c:if>}
	  );


	var contratos = <json:object>
		<json:array name="contratos" items="${persona.contratosPersona}" var="contratoPersona">
			<json:object>
				<json:property name="id" value="${contratoPersona.contrato.id}" />
				<json:property name="cc" value="${contratoPersona.contrato.codigoContrato}" />
		 		<json:property name="tipo" value="${contratoPersona.contrato.tipoProducto.descripcion}" />
		 	 	<json:property name="titulares" value="${contratoPersona.contrato.nombresTitulares}" />
				<json:property name="riesgoContrato" value="${contratoPersona.contrato.lastMovimiento.riesgo}" />
				<json:property name="riesgoIrregular" value="${contratoPersona.contrato.lastMovimiento.deudaIrregular}" />
				<json:property name="riesgoGarantizado" value="${contratoPersona.contrato.lastMovimiento.riesgoGarantizado}" />
				<json:property name="riesgoNoGarantizado" value="${contratoPersona.contrato.lastMovimiento.riesgoNoGarantizado}" />
				<json:property name="limiteDescubierto" value="${contratoPersona.contrato.lastMovimiento.limiteDescubierto}" />
				<json:property name="dispuesto" value="${contratoPersona.contrato.lastMovimiento.dispuesto}" />
		 	 	<json:property name="seleccion">
					<c:if test="${objetivo.contrato.id==contratoPersona.contrato.id}">true</c:if>
		 	 	</json:property>
			</json:object>
		</json:array>
	</json:object>;

	// Si estamos editando guardamos temporalmente el id del contrato del objetivo
	for(var i=0; i < contratos.contratos.length && !idContratoObjetivo; i++) {
		if(contratos.contratos[i].seleccion) {
			idContratoObjetivo = contratos.contratos[i].id;
			recordContratoSeleccionado = i;
		}
	}

	var contratosStore = new Ext.data.JsonStore({
    	data: contratos
    	,root: 'contratos'
    	,fields: [ 'id','cc','tipo','titulares','seleccion','riesgoContrato','riesgoIrregular','riesgoGarantizado','riesgoNoGarantizado','limiteDescubierto','dispuesto']
	});

	Ext.grid.CheckColumn = function(config){
	    Ext.apply(this, config);
	    if(!this.id){
	        this.id = Ext.id();
	    }
	    this.renderer = this.renderer.createDelegate(this);
	};

	Ext.grid.CheckColumn.prototype = {
	    init : function(grid) {
	        this.grid = grid;
	        this.grid.on('render', function(){
	            var view = this.grid.getView();
	            view.mainBody.on('mousedown', this.onMouseDown, this);
	        }, this);
	    },
		<c:if test="${!readOnly}">
		    onMouseDown : function(e, t) {
			        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
			            e.stopEvent();
			            var index = this.grid.getView().findRowIndex(t);
			            var record = this.grid.store.getAt(index);
						var recordAnterior = this.grid.store.getAt(recordContratoSeleccionado);
		
						if(!idContratoObjetivo) {								// Si no hay nada seleccionado, seleccionamos
							record.set(this.dataIndex, true);
							idContratoObjetivo = record.data['id'];
							recordContratoSeleccionado = index;
						} else if(idContratoObjetivo == record.data['id']) {	// Si hicimos click en el seleccionado, des-seleccionamos
							record.set(this.dataIndex, false);
							idContratoObjetivo = null;
							recordContratoSeleccionado = null;
						} else {												// Si hicimos click en otro, des-seleccionamos el anterior
							// Desmarcamos el último check						// y seleccionamos el nuevo
							recordAnterior.set(this.dataIndex, !recordAnterior.data[this.dataIndex]);
							// Marcamos el nuevo check
							record.set(this.dataIndex, !record.data[this.dataIndex]);
							idContratoObjetivo = record.data['id'];
							recordContratoSeleccionado = index;
						}
			        }
					parseResumen();
		    },
		</c:if>
	    renderer : function(v, p, record) {
	        p.css += ' x-grid3-check-col-td'; 
	        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	    }
	};

	var checkColumn = new Ext.grid.CheckColumn({
	    header: '<s:message code="editar.objetivo.grid.seleccion" text="**Selección"/>'
	    ,width: 60
        ,dataIndex: 'seleccion'
      });


	//riesgoContrato
	//riesgoIrregular
	//riesgoGarantizado
	//riesgoNoGarantizado
	//limiteDescubierto
	//dispuesto

	var contratosCm = new Ext.grid.ColumnModel([
		    {dataIndex: 'id',hidden:true,fixed:true}
		    ,checkColumn
		    ,{header: '<s:message code="editar.objetivo.grid.cc" text="**CC"/>', width: 150,  dataIndex: 'cc'}
		    ,{header: '<s:message code="editar.objetivo.grid.tipoproducto" text="**Tipo Producto"/>', width: 160,  dataIndex: 'tipo'}
			,{header: '<s:message code="editar.objetivo.grid.riesgoContrato" text="**riesgoContrato"/>', width: 75, dataIndex: 'riesgoContrato',renderer: app.format.moneyRenderer,align:'right'}
			,{header: '<s:message code="editar.objetivo.grid.riesgoIrregular" text="**riesgoIrregular"/>', width: 75, dataIndex: 'riesgoIrregular',renderer: app.format.moneyRenderer,align:'right'}
			,{header: '<s:message code="editar.objetivo.grid.riesgoGarantizado" text="**riesgoGarantizado"/>', width: 75, dataIndex: 'riesgoGarantizado',renderer: app.format.moneyRenderer,align:'right'}
			,{header: '<s:message code="editar.objetivo.grid.riesgoNoGarantizado" text="**riesgoNoGarantizado"/>', width: 75, dataIndex: 'riesgoNoGarantizado',renderer: app.format.moneyRenderer,align:'right'}
			,{header: '<s:message code="editar.objetivo.grid.limiteDescubierto" text="**limiteDescubierto"/>', width: 75, dataIndex: 'limiteDescubierto',renderer: app.format.moneyRenderer,align:'right'}
			,{header: '<s:message code="editar.objetivo.grid.dispuesto" text="**dispuesto"/>', width: 75, dataIndex: 'dispuesto',renderer: app.format.moneyRenderer,align:'right'}
		]
	);

	var contratosGrid = new Ext.grid.GridPanel({
		store: contratosStore
		,cm: contratosCm 
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,title: '<s:message code="editar.objetivo.grid.contratoParaObjetivo" text="**Contrato para el objetivo"/>'
		,cls: 'cursor_pointer'
		,iconCls: 'icon_contratos_pase'
		,style: 'margin-bottom:10px'
		,width: 850
		,height: 120
		,plugins: checkColumn
	});


	var contratosPanel = new Ext.Panel({
		autoHeight: true
		,autoWidth: true
		,border: false
		,style: 'margin-bottom:10px;'
		,items: [contratosGrid]
	  });

	var resumenObjetivo = new Ext.form.TextArea({
		fieldLabel: '<s:message code="editar.objetivo.resumenObjetivo" text="**Resumen objetivo" />'
		,value: '<s:message javaScriptEscape="true" text="${objetivo.resumen}" />'
		,style: 'margin-bottom:10px;'
		,width: 740
		,height: 50
		,maxLength: 250
		,labelStyle: labelStyle
		<c:if test="${readOnly || chkBoxTxt!=null}">
			,readOnly: true
		</c:if>
	});

	var observaciones = new Ext.form.TextArea({
		fieldLabel: '<s:message code="editar.objetivo.observaciones" text="**Observaciones" />'
		,value: '<s:message javaScriptEscape="true" text="${objetivo.observacion}" />'
		,style: 'margin-bottom:10px;'
		,width: 740
		,height: 50
		,maxLength: 250
		,labelStyle: labelStyle
		<c:if test="${readOnly}">
			,readOnly: true
		</c:if>
	});


	//--------- Form oculto para enviar los datos ------------

	var idObjetivoH = new Ext.form.Hidden({name: 'idObjetivo', value:'${objetivo.id}',hidden:true});
	var idContratoH = new Ext.form.Hidden({name: 'contrato',hidden:true});
	var tipoOperadorH = new Ext.form.Hidden({name: 'tipoOperador',hidden:true});
	var tipoObjetivoH = new Ext.form.Hidden({name: 'tipoObjetivo',hidden:true});
	var fechaLimiteH = new Ext.form.Hidden({name: 'fechaLimite',hidden:true});
	var valorH = new Ext.form.Hidden({name: 'valor',hidden:true});
	var observacionH = new Ext.form.Hidden({name: 'observacion',hidden:true});
	var resumenH = new Ext.form.Hidden({name: 'resumen',hidden:true});
	var justificacionH = new Ext.form.Hidden({name: 'justificacion',hidden:true});
	var estadoItiH = new Ext.form.Hidden({name: 'idEstadoItinerarioPolitica', value:'${idEstadoItinerarioPolitica}',hidden:true});

	var objetivoForm = new Ext.form.FormPanel({
		items:[idObjetivoH,idContratoH,tipoOperadorH,tipoObjetivoH,fechaLimiteH,valorH,observacionH,resumenH,estadoItiH,justificacionH],
		border:false
	  });

	//--------------------------------------------------------


	var btnGuardarAceptar;
	<c:if test="${!readOnly}">
		btnGuardarAceptar = new Ext.Button({
			text: '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls: 'icon_ok'
			,handler: function() {
				tipoObjetivoH.setValue(tipoObjetivoCombo.getValue());				
				fechaLimiteH.setValue(app.format.dateRenderer(fechaLimite.getValue()));
				if(!contratosGrid.disabled) {
					idContratoH.setValue(idContratoObjetivo);
				}
				if(!operadorCombo.disabled) {
					tipoOperadorH.setValue(operadorCombo.getValue());
				}
				if(!cantLimiteNumber.disabled) {
					valorH.setValue(cantLimiteNumber.getValue());
				}
				if(!observaciones.disabled) {
					observacionH.setValue(observaciones.getValue());
				}
				<c:if test="${justificarObjetivo!=null && justificarObjetivo}">
				if (!justificacion.disabled){
					justificacionH.setValue(justificacion.getValue());
				}
				</c:if>
				resumenH.setValue(resumenObjetivo.getValue());
				if(validarForm()) {
					page.submit({
						eventName: 'update'
						,formPanel: objetivoForm
						,success: function() { page.fireEvent(app.event.DONE) }
					  });
				}
			}
		});
	
		var validarForm = function() {
			var errores = '';
			if(!idContratoH.getValue() && !contratosGrid.disabled) {
				errores += '- ' + '<s:message code="editar.objetivo.error.contratoNulo" 
	                             text="**Debe seleccionar un contrato." />' + '<br />';
			}
			if(errores != '') {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>', errores);
				return false;
			}
			return true;
		};
	</c:if>
	<c:if test="${!readOnly || chkBoxTxt!=null}">
		var btnCancelar = new Ext.Button({
			text: '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls: 'icon_cancel'
			,handler: function(){
				page.fireEvent(app.event.CANCEL);
			  }
		});
	</c:if>

	<c:if test="${readOnly}">
		btnGuardarAceptar = new Ext.Button({
			text: '<s:message code="app.aceptar" text="**Aceptar" />'
			,iconCls: 'icon_ok'
			,handler: function(){
				page.fireEvent(app.event.CANCEL);
			  }
		});
	</c:if>

    <c:if test="${chkBoxTxt!=null}">
        var chkBoxAceptar = new Ext.form.Checkbox({
            fieldLabel:'${chkBoxTxt}'
            ,labelStyle: labelStyle
            ,name:'aceptada'
            ,handler:function(){
                changeUpdate();
            }
        });  
    
        var submitAcepto = function(){
            page.submit({
                    eventName : 'aceptar'
                    ,formPanel : objetivoForm
                    ,success : function(){ page.fireEvent(app.event.DONE) }
                });
        }
        
        var submitNoAcepto = function(){
            page.submit({
                    eventName : 'rechazar'
                    ,formPanel : objetivoForm
                    ,success : function(){ page.fireEvent(app.event.DONE) }
                });
        }
        
        var changeUpdate = function(){
            if (chkBoxAceptar.getValue()){
                    btnGuardarAceptar.setHandler(submitAcepto);
                }else{
                    btnGuardarAceptar.setHandler(submitNoAcepto);
                }
        }
        btnGuardarAceptar.setHandler(submitNoAcepto);
    </c:if>

	var parseResumen = function() {
		if(resumenObjetivo.disabled
             && tipoObjetivoCombo.getRawValue()!='') {
			var resumen = '<s:message code="editar.objetivo.parseResumen.el" text="**El" /> ' + tipoObjetivoCombo.getRawValue() + ' ';
			if(!isTipoPersona(tipoObjetivoCombo.getValue()) && idContratoObjetivo!=null) {
				resumen += '<s:message code="editar.objetivo.parseResumen.delContrato" text="**del contrato" /> ' + getCodContratoSeleccionado() + ' ';
			}
			resumen += '<s:message code="editar.objetivo.parseResumen.debeSer" text="**debe ser" /> ' + operadorCombo.getRawValue().toLowerCase() + ' <s:message code="editar.objetivo.parseResumen.a" text="**a" /> ' + cantLimiteNumber.getValue()
	                       + ' <s:message code="editar.objetivo.parseResumen.eurosAntes" text="**\u20AC antes de la fecha" /> ' + app.format.dateRenderer(fechaLimite.getValue());
			resumenObjetivo.setValue(resumen);
		}
	};

	operadorCombo.on('select', parseResumen);
	fechaLimite.on('change', parseResumen);
	cantLimiteNumber.on('change', parseResumen);

	//parseResumen();

	<c:if test="${justificarObjetivo!=null && justificarObjetivo}">
		var justificacionPanel = new Ext.form.FieldSet({
			autoHeight: true
			,autoWidth: true
			,border: false
			,items: [ justificacion ]
	  }); 
	</c:if>

	var topLeftPanel = new Ext.form.FieldSet({
		autoHeight: true
		,autoWidth: true
		,border: false
		,items: [ tipoObjetivoCombo,fechaLimite ]
	  });

	var topRightPanel = new Ext.form.FieldSet({
		autoHeight: true
		,autoWidth: true
		,border: false
		,items: [operadorCombo,cantLimiteNumber]
	  });

	var topPanel = new Ext.Panel({
		autoHeight: true
		,width:850
		,border: false
		,layout: 'table'
		,viewConfig : { columns: 2 }
		,defaults :  { width:400, border : false }
		,items: [ 
			{items:[topLeftPanel],border:false}
			,{items:[topRightPanel],border:false}
		  ]
	  });


	var panelEdicion = new Ext.Panel({
		autoHeight: true
		,autoWidth: true
		,bodyStyle: 'padding:10px'
		,border: false
		,items: [
			 {
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : [
					{ items : [ 
						<c:if test="${justificarObjetivo!=null && justificarObjetivo}">
							justificacionPanel,
						</c:if>
						fieldSetPersona
						,topPanel
						,contratosPanel
						,resumenObjetivo
						,observaciones
						,objetivoForm 
                        <c:if test="${chkBoxTxt != null}">,chkBoxAceptar</c:if>
                        ] }
				]
			}
		]
		,bbar: [
			btnGuardarAceptar <c:if test="${!(readOnly && !((justificarObjetivo!=null && justificarObjetivo))) || chkBoxTxt!=null}">,btnCancelar</c:if>
		]
	});

	tipoObjetivoHandler();

	page.add(panelEdicion);

</fwk:page>
