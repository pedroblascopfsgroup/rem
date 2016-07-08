<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
    var show=false;
    var expedienteActivo = '1';
    
    var Titulo = Ext.data.Record.create([
       	,{name:'id'}
        ,{name:'tipoDocumentoGeneral'}
        ,{name:'tipodocumento'}
        ,{name:'incidencias'}
        ,{name:'intervencion'}
        ,{name:'comentario'}    
    ]);

    <sec:authorize ifAllGranted="NUEVO_TITULO">
    var btnAgregarTitulo = new Ext.Button({
        iconCls : 'icon_mas'
       ,text: '<s:message code="app.agregar" text="**Agregar" />'
       ,cls: 'x-btn-text-icon'
       ,disabled:false
       <app:test id="btnAgregarABM" addComa="true"/>
       ,handler:function(){
           var w = app.openWindow({    
               flow : 'contratos/titulo'
               ,width:550
               ,title : '<s:message code="titulos.agregar.titulo" text="**Agregar titulo" />'
               ,params : {idContrato:${contrato.id},idTitulo:'-1'}
           });
           w.on(app.event.DONE, function(){
               w.close();
               titulosStore.webflow({id:"${contrato.id}"});
               deshabilitarBotones();
           });
           w.on(app.event.CANCEL, function(){ w.close(); });
       }
    });
	</sec:authorize>
	
	<sec:authorize ifAllGranted="BORRA_TITULO">
	    var btnBorrarTitulo = new Ext.Button({
	          text : '<s:message code="titulos.borrar.titulo" text="**Borrar titulo" />'
	         ,iconCls : 'icon_menos'
	         ,cls: 'x-btn-text-icon'
	         ,disabled:true
	         ,handler:function(){
	             var grid = fwk.dom.findParentPanel(this.id);
	             var rec = grid.getSelectionModel().getSelected();
	             page.webflow({
	                 flow : 'expedientes/borrarTitulo'
	                 ,eventName: 'borrar'
	                 ,params : {id:rec.get('id')}
	                 ,success : function() {
	                     titulosStore.webflow({id:"${contrato.id}"});
	                     deshabilitarBotones();
	                 } 
	             });
	         }
		});
	   
	
	   	btnBorrarTitulo.disable();  
    </sec:authorize>
    <sec:authorize ifAllGranted="EDITAR_TITULOS">
    var btnEditarTitulo = new Ext.Button({
            text:'<s:message code="app.editar" text="**Editar" />'
            ,iconCls : 'icon_edit'
            ,cls: 'x-btn-text-icon'
            ,disabled:true
            ,handler:function(){
                var grid = fwk.dom.findParentPanel(this.id);
                var rec = grid.getSelectionModel().getSelected();
                var w = app.openWindow({    
                    flow : 'contratos/tituloContrato'
                    ,width:550
                    ,title : '<s:message code="titulos.edicion.titulo" text="**Editar titulo" />'
                    ,params : {idContrato:${contrato.id}, idTitulo:rec.get('id')}
                });
                w.on(app.event.DONE, function(){
                    w.close();
                    titulosStore.webflow({id:${contrato.id}});
                    deshabilitarBotones();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });
            }
            <app:test id="btnEditarABM" addComa="true"/>
      });
   	  </sec:authorize>	
 
   var deshabilitarBotones = function(){
        <sec:authorize ifAllGranted="EDITAR_TITULOS">
       	  btnEditarTitulo.disable();
       	</sec:authorize>
        <sec:authorize ifAllGranted="BORRA_TITULO">
        	btnBorrarTitulo.disable();
        </sec:authorize>
    }
    
   	var limit = 20;

    var titulosStore = page.getStore({
            flow:'contratos/tabTitulosContratos'
            ,limit:limit
            ,reader: new Ext.data.JsonReader({
                root: 'titulos'
                ,totalProperty : 'total'
            }, Titulo)
        });
    titulosStore.webflow({id:${contrato.id}});    
    var botonesTablaTitulos = fwk.ux.getPaging(titulosStore);
    
    //TODO internacionalizar los headers, acá y en la de expedientes!!!!
    
    var titulosCM  = new Ext.grid.ColumnModel([
        {hidden:true,sortable: false, dataIndex: 'id',fixed:true},
        {header:'Tipo Documento General',dataIndex:'tipoDocumentoGeneral',width:120},
        {header:'Tipo Documento',dataIndex:'tipodocumento',width:120},
        {header:'Incidencias',dataIndex:'incidencias',width:120},
        {header:'Intervencion',dataIndex:'intervencion',width:120,renderer:app.format.booleanToYesNoRenderer},
        {header:'Comentario',dataIndex:'comentario',width:120}
    ]);
   
   var bar = [botonesTablaTitulos];
   var pos = 1;

  <sec:authorize ifAllGranted="NUEVO_TITULO">	 	
   	bar[pos] = btnAgregarTitulo;
   	pos++
  </sec:authorize>
   
  <sec:authorize ifAllGranted="EDITAR_TITULOS">
  	bar[pos]= btnEditarTitulo;
   	pos++;
  </sec:authorize>
  <sec:authorize ifAllGranted="BORRA_TITULO">
   	bar[pos] = btnBorrarTitulo;
  </sec:authorize>	
  
    var titulosGrid= app.crearGrid(titulosStore,titulosCM,{
        title:'<s:message code="expedientes.consulta.tabtitulos.titulo" text="**Titulos"/>'
        ,style : 'margin-bottom:5px;padding-right:0px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:448
        ,bbar:bar
        ,iconCls : 'icon_titulo'
    });

	titulosGrid.on('rowclick', function(grid, rowIndex, e){

        var rec = grid.getStore().getAt(rowIndex);
        if(rec.get('id') != ''){
            <sec:authorize ifAllGranted="EDITAR_TITULOS">
            btnEditarTitulo.enable();
            </sec:authorize>
            <sec:authorize ifAllGranted="BORRA_TITULO">
            btnBorrarTitulo.enable();
            </sec:authorize>
    	}else{
            <sec:authorize ifAllGranted="EDITAR_TITULOS">
            btnEditarTitulo.disable();
            </sec:authorize>
            <sec:authorize ifAllGranted="BORRA_TITULO">
            btnBorrarTitulo.disable();
            </sec:authorize>
    	}
    }); 
    
    var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabtitulos.titulo" text="**Titulos"/>'
        ,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:0px'
        ,items:[titulosGrid]
        ,autoHeight:true
        ,listeners:
        {
            show:function(){
                if(!show){
                    show=true;
                }
            }
        }
		,nombreTab : 'tabTitulosContratos'
    });

    return panel;
})()