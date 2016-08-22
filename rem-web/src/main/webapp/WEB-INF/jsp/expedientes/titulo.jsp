<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>


<fwk:page>
    var labelStyle='font-weight:bolder;width:150'
    
    var tipoDocGen = <app:dict value="${tiposDocumentoGeneral}" blankElement="false" />;
    var tiposDocumento= <app:dict value="${tiposDocumento}" />;
    
    var comboTipoDocGen = app.creaCombo({
        data:tipoDocGen
        ,triggerAction: 'all'
        ,labelStyle:labelStyle
        ,forceSelection:true 
        ,fieldLabel : '<s:message code="titulos.edicion.tipodocumentoGeneral" text="**Tipo Documento General" />'
		,width: 230
    });

    var recargarComboTipoDoc = function(){
        optionsTipoDocStore.webflow({codigoTipoDocGen: comboTipoDocGen.getValue()});
    };
    
    var limpiarYRecargar = function(){
        recargarComboTipoDoc();
        comboTipoDocumento.reset();
        //comboTipoDocumento.store.reload();
    };
    
    comboTipoDocGen.on('select',limpiarYRecargar);
    
    var tipoDocRecord = Ext.data.Record.create([
         {name:'codigo'}
        ,{name:'descripcion'}
    ]);
    
    var optionsTipoDocStore = page.getStore({
           flow: 'expedientes/buscarTiposDocumento'
           ,reader: new Ext.data.JsonReader({root : 'tiposDocumento'}, tipoDocRecord)           
    }); 
    var style='margin-bottom:1px;margin-top:1px';
    var comboTipoDocumento = new Ext.form.ComboBox({
                store: optionsTipoDocStore
                ,displayField:'descripcion'
                ,valueField:'codigo'
                ,mode: 'local'
                ,forceSelection:true 
                ,triggerAction: 'all'
                ,editable: false
                ,labelStyle:labelStyle
                ,style:style
                ,maxHeight: 140
				,resizable: true
				,width: 230
                ,fieldLabel : '<s:message code="titulos.edicion.tipodocumento" text="**Tipo Documento" />'
                ,name: 'comboTipoDocumento'
    });

    var comboEstadoDocumento = app.creaCombo({
        data : <app:dict value="${situaciones}" />
        ,fieldLabel : '<s:message code="titulos.edicion.estadodocumento" text="**Estado Documento" />'
        ,labelStyle:labelStyle
		,width: 230
        <app:test id="idComboEstadoDocumento" addComa="true" />
    });
    
    var txtContrato = app.creaLabel('<s:message code="titulos.edicion.contrato" text="**Contrato"/>','${dtoTitulo.contrato.codigoContrato}',{labelStyle:labelStyle});
    var txtTipoContrato = app.creaLabel('<s:message code="titulos.edicion.tipocontrato" text="**Tipo de Contrato"/>','${dtoTitulo.contrato.tipoProducto.descripcion}',{labelStyle:labelStyle});
    
    var chkIntervencion = new Ext.form.Checkbox({
        fieldLabel:'<s:message code="titulos.edicion.intervencion" text="**Intervencion" />'
        ,labelStyle:labelStyle
        <app:test id="idCheckIntervencion" addComa="true"/>
    });
    
    

    var comentario = new Ext.form.TextArea({
            fieldLabel:'<s:message code="titulos.edicion.comentario" text="**Comentario" />'
            ,width: 350
			,height: 175
            ,labelStyle:labelStyle
            , maxLength: 250
            <app:test id="campoParaComentario" addComa="true"/>
        });
    
    var validarCampos = function(){
    	if (comboTipoDocumento.getValue()==null || comboTipoDocumento.getValue()==='' ){
    		return false;
    	}
    	if (comboEstadoDocumento.getValue()==null || comboEstadoDocumento.getValue()==='' ){
    		return false;
    	}
/*
    	if (comentario.getValue()==null || comentario.getValue()==='' ){
    		return false;
    	}
*/
    	return true;
    }
    
    var btnGuardar = new Ext.Button({
        text : '<s:message code="app.guardar" text="**Guardar" />'
        ,iconCls : 'icon_ok'
        ,handler : function(){
          if (validarCampos()){  
            var params = {codigoTipo:comboTipoDocumento.getValue()
                          ,codigoSituacion:comboEstadoDocumento.getValue()
                          ,intervenido:chkIntervencion.getValue()
                          ,comentario:comentario.getValue()};
            page.submit({
                eventName : 'update'
                ,formPanel : panel
                ,params: params
                ,success : function(){ page.fireEvent(app.event.DONE) }
            });
          } else {
          	//mostrar alert
          	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="titulos.errorEdicion" text="**Debe ingresar tipo de documento, estado y comentario" />');
          }
        }
        <app:test id="btnGuardarABM" addComa="true"/>
    });

    var btnCancelar= new Ext.Button({
        text : '<s:message code="app.cancelar" text="**Cancelar" />'
        ,iconCls:'icon_cancel'
        ,handler : function(){
            page.fireEvent(app.event.CANCEL);
        }
    });
    var panel = new Ext.form.FormPanel({
        autoHeight : true
        ,autoWidth:true
        ,bodyStyle : 'padding:10px'
        ,border : false
        ,items : [
        
             { xtype : 'errorList', id:'errL' }
            ,{ 
                border : false
                ,layout : 'column'
                ,viewConfig : { columns : 1 }
                ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:550 }
                ,items : [
                    { items : [     
                        txtContrato
                        ,txtTipoContrato
                        ,comboTipoDocGen
                        ,comboTipoDocumento
                        ,comboEstadoDocumento
                        ,chkIntervencion
                        ,comentario
                    ]
                    ,style : 'margin-right:10px' }
                ]
            }
        ]
        ,bbar : [
            btnGuardar,btnCancelar
        ]
    });

    var setTipoDocValue = function() {
        comboTipoDocumento.setValue(${dtoTitulo.titulo.tipoTitulo.codigo});
        comboTipoDocumento.enable();
        optionsTipoDocStore.un('load',setTipoDocValue);
    }

    var loadCombos = function() {
        if(${idTitulo} == -1) return;
        comboTipoDocGen.setValue(${dtoTitulo.titulo.tipoTitulo.tipoTituloGeneral.codigo});
        if (comboTipoDocGen.getValue()!=''){
        	recargarComboTipoDoc();
        }
        optionsTipoDocStore.on('load',setTipoDocValue);
      
        comboEstadoDocumento.setValue(${dtoTitulo.titulo.situacion.codigo});
        comentario.setValue('${dtoTitulo.titulo.comentario}');
        if(new Boolean(${dtoTitulo.titulo.intervenido}) == true) {
            chkIntervencion.checked=true;
        }
    };
    loadCombos();

    
    page.add(panel);
</fwk:page>

