$(document).ready(function () {

    //娉ㄥ唽鐧诲綍妗唗ab鍒囨崲;
    $(".vipC-tabs a").click(function () {
        var cls = $(this).attr("class");
        if (cls.indexOf("hover") > 0) return;
        var str = catchString($(this).attr("class"));

        $(".vipC-tabs a").removeClass("hover");
        $(this).addClass("hover");

        $(".vipC_tabsCon").css({ "display": "none" });
        $("#tabsCon" + str).css({ "display": "block" })
    })


    //鍒ゆ柇杈撳叆妗嗘槸鍚︽湁鍊硷紝涓斿垽鏂緭鍏ユ鍐呯殑鏂囧瓧鏄惁鍜宑ontent灞炴€х殑涓€鑷�;
    $(".vipC_tabsCon input[type!=checkbox]").focusin(function () {
        if ($(this).attr("content") == $(this).val() && $(this).attr("typecon") != "password") {
            $(this).val("");
        }
        else if ($(this).attr("typecon") == "password") {
            var thisObj = $(this);
            thisObj.next().focus(function () {
                thisObj.hide();
                thisObj.next().show();
            });
        }
    })
    $("input[typecon='password']").focusin(function () {
        $(this).next().focus();
    })
    $("#tabsCon1 input[type!=checkbox]").focusout(function () {
        if ($(this).attr("content") != $(this).val() && $(this).val() != "") {
            hide_error($(this));
        }
    });

    //鐧诲綍
    var $lName = $("#name");
    var $lPassWord = $("#password");
    var $btnLogin = $("#btnLogin");

    function checkLoginName() {
        if ($lName.val() == "" || $lName.attr("content") == $lName.val()) {
            show_error($lName, "鐢ㄦ埗鍚嶄笉鑳界偤绌�");
            $lName.focus();
            return false;
        } else {
            hide_error($lName);
            return true;
        }
    }
    function checkLoginPwd() {
        if ($lPassWord.val() == "") {
            show_error($lPassWord, "瀵嗙⒓涓嶈兘鐐虹┖");
            $lPassWord.focus();
            return false;
        } else {
            hide_error($lPassWord);
            return true;
        }
    }

    $btnLogin.on('click', function () {
        var flag = checkLoginName();
        if (flag) {
            flag = checkLoginPwd();
        }
        return flag;
    });
    jQuery('#loginform').jValidate({
        blurvalidate: true,
        isbubble: true,
        oncompleted: function (form) {
            var userpass = $('#password');
            var repass = userpass.val().split('').reverse().join('');
            userpass.val(hex_md5(userpass.val() + '' + repass));
            jQuery(form).ajaxPost(function (result) {
                userpass.val('');
                if (result.success) {
                    if (typeof afterLoginSuccess == "function") {
                        afterLoginSuccess();
                    } else {
                        self.location.href = result.url;
                    }
                } else {
                    alert(result.message);
                }
            });
            return false;
        }
    });
    // end 鐧诲綍


    //娉ㄥ唽
    var $rName = $("#registerName");
    var $rMobilePhone = $("#mobliePhone");
    var $rEmail = $("#email");
    var $rPassWord = $("#registerPassword");
    var $rPassWord2 = $("#registerPassword2");
    var $code = $("#code");
    var $btnRegister = $("#btnRegister");
    var $vc = $("#vc");

    var checkrName = false;
    var checkrPwd = false;
    var checkrPwd2 = false;
    var checkrMail = false;
    var checkrPhone = false;
    var checkrCode = false;

    var funCheckName = function () {
        if ($rName.val() == "" || $rName.attr("content") == $rName.val()) {
            show_error($rName, "鐢ㄦ埗鍚嶄笉鑳界偤绌�");
            // $rName.focus();
            return false;
        }
        $.post('?', {
            "ajaxhandler": 'checkname',
            "name": $rName.val()
        }, function (result) {
            if (result.success) {
                hide_error($rName);
                checkrName = true;
                return true;
            } else {
                show_error($rName, result.message);
                //  $rName.focus();
                return false;
            }
        }
             , 'json');
    };

    var funCheckPhone = function () {
        if ($rMobilePhone.val() == "" || $rMobilePhone.attr("content") == $rMobilePhone.val()) {
            show_error($rMobilePhone, "璜嬪～瀵湡瀹炴墜姗熻櫉纰硷紝浠ユ柟渚挎帴鏀剁煭淇℃彁閱掑姛鑳姐€�");
            //$rMobilePhone.focus();
            return false;
        }
        else if ($rMobilePhone.val().length != 11) {
            show_error($rMobilePhone, "鎵嬫铏熺⒓鏍煎紡閷銆�");
            //$rMobilePhone.focus();
            return false;
        }
        hide_error($rMobilePhone);
        checkrPhone = true;
        return true;
    };

    var funCheckEmail = function () {
        if ($rEmail.val() == "" || $rEmail.attr("content") == $rEmail.val()) {
            show_error($rEmail, "璜嬪～瀵纰洪兊绠卞湴鍧€銆�");
            //$rEmail.focus();
            return false;
        }
        else if (!(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/.test($rEmail.val()))) {
            show_error($rEmail, "閮电鍦板潃鏍煎紡閷銆�");
            //$rEmail.focus();
            return false;
        }
        $.post('?', {
            "ajaxhandler": 'checkmail',
            "email": $rEmail.val()
        }, function (result) {
            if (result.success) {
                hide_error($rEmail);
                checkrMail = true;
                return true;
            } else {
                show_error($rEmail, result.message);
                // $rEmail.focus();
                return false;
            }
        }
             , 'json');
    };

    var funCheckPwd1 = function () {
        if ($rPassWord.val() == "") {
            // $rPassWord.focus();
            show_error($rPassWord, "瀵嗙⒓涓嶈兘鐐虹┖");
            return false;
        }
        else if ($rPassWord.val().length < 4) {
            show_error($rPassWord, "璜嬭几鍏ヨ嚦灏�4浣嶅瓧绗︿綔鐐哄瘑纰�");
            //  $rPassWord.focus();
            return false;
        }
        hide_error($rPassWord);
        checkrPwd = true;
        return true;
    };
    var funCheckPwd2 = function () {
        if ($rPassWord2.val() == "") {
            show_error($rPassWord2, "纰鸿獚瀵嗙⒓涓嶈兘鐐虹┖");
            //$rPassWord2.focus();
            return false;
        }
        else if ($rPassWord.val() != $rPassWord2.val()) {
            show_error($rPassWord2, "鍏╂瀵嗙⒓杓稿叆涓嶅９鑷�");
            // $rPassWord2.focus();
            return false;
        }
        hide_error($rPassWord2);
        checkrPwd2 = true;
        return true;
    };
    var funCheckCode = function () {
        if ($code.val() == "" || $code.attr("content") == $code.val()) {
            show_error($code, "椹楄瓑纰间笉鑳界偤绌�");
            //  $code.focus();
            return false;
        }
        hide_error($code);
        checkrCode = true;
        return true;
    };

    $rMobilePhone.blur(funCheckPhone);
    $rName.blur(funCheckName);
    $rEmail.blur(funCheckEmail);
    $rPassWord.blur(funCheckPwd1);
    $rPassWord2.blur(funCheckPwd2);
    $code.blur(funCheckCode);

    var isPost = false;
    $btnRegister.click(function () {
        if (isPost) return false;
        if (!checkrName && !funCheckName()) {
            return false;
        }

        if (!checkrPwd && !funCheckPwd1()) {
            return false;
        }

        if (!checkrPwd2 && !funCheckPwd2()) {
            return false;
        }

        if (!checkrPhone && !funCheckPhone()) {
            return false;
        }

        if (!checkrMail && !funCheckEmail()) {
            return false;
        }

        if (!checkrCode && !funCheckCode()) {
            return false;
        }

        if ($("#agree").attr("checked") != "checked") {
            alert("璜嬪厛鍚屾剰浣跨敤鍗旇");
            return false;
        }
        isPost = true;
        $(".loading_img,.loading_bg").show();
        $.post('?', {
            "ajaxhandler": 'register',
            "name": $rName.val(),
            "mobilephone": $rMobilePhone.val(),
            "email": $rEmail.val(),
            "password": $rPassWord.val(),
            "code": $code.val(),
            "platform": $("#platform").val(),
            "platform_params": $("#platform_params").val(),
            "sign_code": $("#sign_code").val(),
            "autoLogin": true,
            "vc": $("#vc").val()
        }, function (result) {
            isPost = false;
            $(".loading_img,.loading_bg").hide();
            if (result.success) {
                $("#go_to_mail").attr("href", getMailAddr($("#email").val()));
                $('#registerform')[0].reset();
                $('#cfaction').val('register');
                $(".login_register").hide();
                $(".register_success").show();
            } else {
                alert(result.message);
                refValidCode();
            }
        }
             , 'json').error(function () {
                 $(".loading_img,.loading_bg").hide();
                 isPost = false;
                 alert("缃戠粶閾炬帴澶辫触锛岃珛绋嶅悗鍐嶈瘯锛�");
                 refValidCode();
             });
        return false;
    });

    //娉ㄥ唽 end

    function show_error(objs, msg) {
        var _this = objs;
        if (objs.prev()[0].tagName == "SPAN") {
            objs = _this.prev();
        } else {
            objs = _this.prev().prev();
        }
        objs.find("b").text(msg);
        $(".tipsBlock").hide();

        tips_In_Animation(objs);
    }
    function hide_error(objs) {
        var _this = objs;
        if (objs.prev()[0].tagName == "SPAN") {
            objs = _this.prev();
        } else {
            objs = _this.prev().prev();
        }
        tips_Out_Animation(objs);
    }

    //鎻愮ず妗嗙偣鍑诲厜鏍囧姩鐢�
    function tips_In_Animation(obj) {
        obj.css({ "display": "block", "opacity": 0 });
        obj.find("span").css({ "width": "100px", "margin-left": "70px", "background-image": "none" })
        obj.stop().animate({ "top": "34px", "opacity": 0.4 }, 100, function () {
            obj.find("span").stop().animate({ "width": "235px", "opacity": 1, "margin-left": "0px" }, 100, function () {
                obj.stop().animate({ "opacity": 1 }, 200, function () {
                    obj.find("span i").stop().animate({ "opacity": 1 }, 100, function () {
                        obj.find("span b").stop().animate({ "opacity": 1, "margin-left": 0 }, 100, function () {
                        })

                    });
                })
            })
        });
    }

    //鎻愮ず妗嗙寮€鍏夋爣鍔ㄧ敾
    function tips_Out_Animation(obj) {
        obj.find("span b").stop().animate({ "opacity": 0, "margin-left": "-20px" }, 200, function () {
            obj.find("span i").stop().animate({ "opacity": 0 }, 200, function () {
                obj.find("span").stop().animate({
                    "width": "100px",
                    "opacity": 0.5,
                    "margin-left": "70px"
                }, 200, function () {
                    obj.stop().animate({ "top": "0", "opacity": 0 }, 200, function () {
                        obj.hide();
                    })
                })
            })
        })
    }

    //鎴彇鏈€鍚庝竴涓瓧绗�
    function catchString($str) {
        return $str.substr($str.length - 1, 1);
    }
})

function afterLoginSuccess() {
    var cfaction = $('#cfaction');
    if (cfaction.val() == '') {
        cfaction.val('login');
    }
    $('#callbackForm').submit();
}

function refValidCode() {
    document.getElementById("validcode").src = "/captcha.ashx?" + Math.random();
}