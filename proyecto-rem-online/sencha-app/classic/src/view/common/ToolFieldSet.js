Ext.define('HreRem.view.common.ToolFieldSet', {
    extend: 'Ext.form.FieldSet',
    alias: 'widget.toolfieldset',
    createLegendCt: function () {
       
        var me = this,
            items = [],
            legendCfg = {
            	width: '100%',
                baseCls: me.baseCls + '-header',
                // use container layout so we don't get the auto layout innerCt/outerCt
                layout: 'container',
                ui: me.ui,
                id: me.id + '-legend',
                autoEl: 'legend',
                ariaRole: null,
                items: items,
                ownerCt: me,
                //shrinkWrap: true,
                ownerLayout: me.componentLayout
            },
            legend;

        // Checkbox
        if (me.checkboxToggle) {
            items.push(me.createCheckboxCmp());
        } else if (me.collapsible) {
	        // Toggle button
            items.push(me.createToggleCmp());
        }

        // Title
        items.push(me.createTitleCmp());
        
        // Add Extra Tools
        if (Ext.isArray(me.tools)) {
        	var buttons = [];        	
    		//buttons.push(Ext.create("Ext.toolbar.Fill"));    		
            for(var i = 0; i < me.tools.length; i++) {
                 buttons.push(me.createButtonCmp(me.tools[i]));
            }
            
            items.push(me.createToolBarCmp(buttons))
        }
        
        legend = new Ext.container.Container(legendCfg);
        
        // Mark the legend as immune to collapse so that when the fieldset
        // *is* collapsed and the toggle tool or checkbox is focused,
        // calling isVisible(true) on it will return true instead of false.
        // See also below in createCheckboxCmp and createToggleCmp.
        legend.collapseImmune = true;
        legend.getInherited().collapseImmune = true;
        
        return legend;

        
    },

    createButtonCmp: function(toolCfg) {
        return Ext.widget(toolCfg);
    },
    
    createToolBarCmp: function(buttons) {
    	var me = this,
    	items = [],
    	toolbarCfg = {};
    	
        Ext.apply(toolbarCfg, {
            xtype:  'toolbar',
            style:'padding: 0px',
            flex: 1,
            items: buttons            
        });
        
        return Ext.widget(toolbarCfg);
    	
    }

});