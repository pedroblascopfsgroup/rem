<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var estadoPoliticaStore;

var createDatosPoliticaPanel = function() {

//----------------------------------------------------------------------
// Tabla de datos
//----------------------------------------------------------------------


    var estadoPolitica = Ext.data.Record.create([
        {name : 'id'}
        ,{name : 'estado'}
        ,{name : 'fecha'}
        ,{name : 'gestor'}
        ,{name : 'usuario'}        
        ,{name : 'supervisor'}
        ,{name : 'politica'}
        ,{name : 'vigente'}
    ]);

    estadoPoliticaStore = page.getStore({
        event:'listado'
        ,flow : 'politica/listadoEstadosPolitica'
        ,reader : new Ext.data.JsonReader(
            {root:'estadosPolitica'}
            , estadoPolitica
        )
    });

    var estadosCm = new Ext.grid.ColumnModel([
            {header :'estado', dataIndex : 'estado'}
            ,{header :'fecha', dataIndex : 'fecha'}
            ,{header :'usuario',dataIndex : 'usuario'}
            ,{header :'gestor', dataIndex : 'gestor'}
            ,{header :'supervisor', dataIndex : 'supervisor'}
            ,{header :'politica',dataIndex : 'politica'}
        ]);   

    var configEstados = {
        title: '<s:message code="politica.datosPolitica" text="**Datos de una política" />'
        ,heigth: '210px'
        ,style: 'padding-bottom:10px'};

    var datosGrid = app.crearGrid(estadoPoliticaStore, estadosCm, configEstados);

    datosGrid.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.getStore().getAt(rowIndex);
        objetivosStore.webflow({idEstado:rec.get('id')});
        var editable=rec.get('vigente');
        if(editable) {
            objetivosGrid.getBottomToolbar().enable();
        } else {
            objetivosGrid.getBottomToolbar().disable();
        }
    });

    return datosGrid;
};