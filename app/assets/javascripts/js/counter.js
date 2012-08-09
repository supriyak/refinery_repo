var odometers = {
    stack: [], // stack for the odometers
    links: {},
    ticker: false,
    period: 10, // speed of the events in ms (1000 = 1sec)
    // callback function for the ticker
    tick: function(){
        var odo = odometers;
        // processing all odometers on the page
        for(var i = odo.stack.length;--i>=0;)
            odo.stack[i].tick_handler();
        odo.ticker = setTimeout(odo.tick, odo.period);
    },
    // registering new odometer to be processed
    add_new: function(odometer){
        var cnt = this.stack.length;
        this.stack[cnt] = odometer;
        return cnt;
    },
    // starting the ticker
    start: function(){
        this.ticker = setTimeout(this.tick, this.period);
    },
    // stoping the ticker, of course:)
    stop: function(){
        clearTimeout(this.ticker);
    },
    init: function(ini){
        this.period = ini && ini.period ? ini.period : this.period;
        this.start();
        $('.odometer').each(function(){
            var
                tmp,
                id = $(this).attr('id'),
                wheels = (tmp = $(this).attr('wheels')) ? tmp : 'auto',
                value = (tmp = $(this).attr('svalue')) ? tmp : 0;
            tmp = odometers.add_new(new odometer({
                target: '#' + id,
                wheels: wheels,
                value: value,
                // text to prepend wheels
                ptext: $(this).attr('ptext'),
                // text after wheels
                atext: $(this).attr('atext')
            }));
            odometers.links[id] = tmp;
        });
    },
    ctrl: function(id){
        return this.stack[this.links[id]];
    }
}

function odometer(init){
    var obj = {
        wheels: [], // wheels storage
        top_speed: 5, // rotation increment top border, bigger is faster
        ctrl: false, // holder for the odometer DIV element
        value: 0, // current value of the odometer
        // initiation of the class
        init: function(init){
            this.ctrl = $(init.target)
                .addClass('odometer')
                .empty();
            this.value = init.value ? init.value.toString() : '0';
            if(!init.wheels || init.wheels && ( init.wheels == 'auto' || init.wheels == 'auto_group')){
                switch(init.wheels){
                    case 'auto':
                        init.wheels = this.value.length;
                        if(this.value.charAt(0) == 9) init.wheels++;
                        break;
                    case 'auto_group':
                        var tmp = this.value.toString().length;
                        init.wheels = tmp % 3 ? Math.round(tmp / 3) * 3 : tmp;
                        break;
                }
            }
            var ic = 0, ptw = 0, atw = 0;
            // wheels creation
            for(var i = init.wheels;--i>=0;){
                this.wheels[i] = this._add_wheel(this.ctrl);
                this.wheels[i].odometer = this;
                // adding space between each 3 wheels and if this is not first one
                if(++ic % 3 == 0 && i>0){
                    $('<span>, </span>')
                        .addClass('space')
                        .prependTo(this.ctrl);
                }
            }
            if(init.ptext){ // if there prepend wheels text
                var tmp = $('<span></span>')
                    .html(init.ptext)
                    .addClass('text')
                    .prependTo(this.ctrl);
                ptw = tmp[0].offsetWidth;
            }
            if(init.atext){ // if there after wheels text
                var tmp = $('<span></span>')
                    .html(init.atext)
                    .addClass('text')
                    .appendTo(this.ctrl);
                atw = tmp[0].offsetWidth;
            }
            this.ctrl.css('white-space', 'nowrap');
            this.set_value(this.value);
            // registering in the ticker
//             odometer_ticker.add_new(this);
            return this;
        },
        set_value: function(value){
            // left padding value with zeros
            value = value ? value.toString() : '0';
            for(var i = value.length; i<this.wheels.length;i++) value = '0' + value;
            // setup wheels values
            for(var i = this.wheels.length;--i>=0;) this.wheels[i].set_value(parseInt(value.charAt(i)));
        },
        _add_wheel: function(owner){
            var wobj = {
                odometer: true, // pointer to the owner
                cxpos: 33, // current X coordinate
                txpos: 33, // target X coordinate
                value: 0, // current digit value of wheel
                tvalue: 0, // target digit value
                ctrl: false, // pointer to wheel html control
                inc: 1, // current increment
                bounce: false, // bounce effect flag
                // wheel initiation
                init: function(wdata){
                    var tmp = $('<span></span>')
                        .addClass('wheel')
                        .prependTo(owner);
                    this.ctrl = $('<span></span>')
                        .addClass('dig')
                        .appendTo(tmp);
                    return this;
                },
                set_top: function(top){
                    this.ctrl[0].style.top = (top <= 0 ? top : -top) + 'px';
//                     this.ctrl.css('top', top <= 0 ? top : -top);
                },
                // if we reach the end of the image, rollback to the start to show rotation effect
                check_ranges: function(){
                    // each digit height is 16px. this will jump from last 9 to first 9
                    //this.cxpos=318;
                    if(this.cxpos > 340) this.cxpos -= 325;
                },
                tick: function(){ // tick processing
                    // position is reached? then exit
                    if(this.value == this.tvalue) return;
                    // calculating next increment value if is not bounce mode
                    if(this.bounce === false) this.inc = Math.sqrt(Math.max(this.cxpos, this.txpos) - Math.min(this.cxpos, this.txpos));
                    // if increment value is greater then allowed border - limit it
                    if(this.inc > this.odometer.top_speed) this.inc = this.odometer.top_speed
                    // in bounce mode we need to move back
                    if(this.bounce) this.cxpos -= this.inc; else this.cxpos += this.inc;
                    this.check_ranges();
                    this.set_top(Math.round(this.cxpos));
                    // is target position reached?
                    if(Math.round(this.cxpos) == this.txpos) {
                        // position reached, bounce not activated yet
                        if(this.bounce === false){
                            // target position for bounce effect
                            this.txpos -= 4;
                            this.bounce = true;
                            this.inc = 0.5;
                        } else if(this.bounce === true) {
                            // target for bouce reached, setting up new target and set bounce flag
                            this.txpos = (this.tvalue+1) * 32;
                            this.bounce = 0;
                        } else {
                            // rotation and bounce complete
                            this.cxpos = this.txpos;
                            this.value = this.tvalue;
                        }
                    }
                },
                // setup value for the wheel
                set_value: function(value){
                    if(this.tvalue == value) return;
                    this.tvalue = value;
                    this.txpos = (value+1) * 32;
                    this.bounce = false;
                }
            };
            return wobj.init(owner);
        },
        tick_handler: function(){
            // processing wheels
            for(var i = this.wheels.length;--i>=0;){
                this.wheels[i].tick();
            }
        }
    };
    return obj.init(init);
}

