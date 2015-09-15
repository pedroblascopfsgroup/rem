if (!window["console"]){
    console = function(){};
    //console.debug=function(){};
}
ExtUtil ={};
ExtUtil.combo = function(values,config){
    config =    config || {};
    var cfg = Ext.applyIf(config,{
        width:40
        ,mode: 'local'
      //  ,editable : false
        ,typeAhead : true
        ,forceSelection : true
        ,disableKeyFilter : true
        ,store: new Ext.data.ArrayStore({
            id: 0
            ,fields: [ 'myId', 'displayText' ]
            ,data: values
            })
        ,valueField: 'myId'
        ,triggerAction :    'all'
        ,lastQuery : ''
        ,displayField: 'displayText'
        ,listeners: {
            // delete the previous query in the beforequery event or set
            // combo.lastQuery = null (this will reload the store the next time it expands)
            beforequery: function(qe){
               // delete qe.combo.lastQuery;
            }
        }
    });
    var combo=new Ext.form.ComboBox(cfg);
    combo.on("change", function(){
            //delete qe.combo.lastQuery;
    });
    return combo;
}


ExtUtil.label = function(text){
    return new Ext.form.Label({
            text : text
            ,style : 'border-right:5px solid white'
    });
}
ExtUtil.label2 = function(text){
    return new Ext.form.Label({
            text : text
            ,style : 'border-right:5px solid white;border-left:5px solid white'
    });
}

ExtUtil.list = function(values, config){
    config =    config || {};
    var store  =  new Ext.data.ArrayStore({
            id: 0
            ,fields: [ 'value', 'text' ]
            ,data: values
            })   
    var cfg = Ext.applyIf(config,{
        width:240
        ,mode: 'local'
        ,store: store
        ,lastQuery : ''
         ,multiselects: [{
                legend :    'Disponibles',
                width: 160,
                height: 200,
                store: store,
                displayField: 'text',
                valueField: 'value'
            },{
                legend :    'Seleccionados',
                width: 160,
                height: 200,
                store: [["", "nada seleccionado"]],
                displayField: 'text',
                valueField: 'value'
            }]

    });
    var selector=new Ext.ux.form.ItemSelector(cfg);
    return selector;
}
