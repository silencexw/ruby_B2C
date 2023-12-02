(function() {

    //生成订单
    $('.create-transaction_order-form').submit(function() {
        var addressID = $('input[name="address_id"]:checked').val(),
            $form = $(this);

        if (!addressID) {
            alert("请选择收货地址!");
            return false;
        } else {
            $form.find('input[name="address_id"]').val(addressID);
            return true;
        }
    })

    //收货地址
    $(document).on('click', '.new-address-btn', function() {
        $.get('/addresses/new', function(data) {
            if ($('#address_form_modal').length > 0) {
                $('#address_form_modal').remove();
            }

            $('body').append(data);
            $('#address_form_modal').modal();
        })

        return false;
    })
        .on('ajax:success', '.address-form', function(e, data) {
            if (data.status == 'ok') {
                $('#address_form_modal').modal('hide');
                $('#address_list').html(data.data);
            } else {
                $('#address_form_modal').html($(data.data).html());
            }
        })
        .on('ajax:success', '.edit-address-btn', function(e, data) {
            if ($('#address_form_modal').length > 0) {
                $('#address_form_modal').remove();
            }

            $('body').append(data);
            $('#address_form_modal').modal();
        })
        .on('ajax:success', '.set-default-address-btn, .remove-address-btn', function(e, data) {
            $('#address_list').html(data.data);
        })

    const editAvatarBtn = document.getElementById('edit-avatar-btn');
    const editNameBtn = document.getElementById('edit-name-btn');
    const editSignatureBtn = document.getElementById('edit-signature-btn');
    const editPasswordBtn = document.getElementById('edit-user_message-btn');
    const modal = document.getElementById('modal');
    const modalTitle = document.getElementById('modal-title');
    const modalForm = document.getElementById('modal-form');
    const modalSaveBtn = document.getElementById('modal-save-btn');
    const modalCancelBtn = document.getElementById('modal-cancel-btn');

// 点击修改头像按钮
    editAvatarBtn.addEventListener('click', () => {
        showModal('修改头像', 'avatar');
    });

// 点击修改姓名按钮
    editNameBtn.addEventListener('click', () => {
        showModal('修改姓名', 'name');
    });

// 点击修改个性签名按钮
    editSignatureBtn.addEventListener('click', () => {
        showModal('修改个性签名', 'signature');
    });

// 点击修改密码按钮
    editPasswordBtn.addEventListener('click', () => {
        showModal('修改密码', 'password');
    });

// 显示弹窗
    function showModal(title, type) {
        modalTitle.textContent = title;
        modal.style.display = 'block';

        // 清空表单字段
        modalForm.innerHTML = '';

        // 根据类型添加相应的表单字段
        if (type === 'avatar') {
            // 添加头像修改表单字段
            const avatarInput = document.createElement('input');
            avatarInput.type = 'file';
            avatarInput.name = 'avatar';
            modalForm.appendChild(avatarInput);
        } else if (type === 'name') {
            // 添加姓名修改表单字段
            const nameInput = document.createElement('input');
            nameInput.type = 'text';
            nameInput.name = 'name';
            modalForm.appendChild(nameInput);
        } else if (type === 'signature') {
            // 添加个性签名修改表单字段
            const signatureInput = document.createElement('textarea');
            signatureInput.name = 'signature';
            modalForm.appendChild(signatureInput);
        } else if (type === 'password') {
            // 添加密码修改表单字段
            const passwordInput = document.createElement('input');
            passwordInput.type = 'password';
            passwordInput.name = 'password';
            modalForm.appendChild(passwordInput);
        }
    }

// 点击保存按钮
    modalSaveBtn.addEventListener('click', () => {
        // 处理保存逻辑
        closeModal();
    });

// 点击取消按钮或弹窗外部区域
    modalCancelBtn.addEventListener('click', () => {
        closeModal();
    });

    window.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });

// 关闭弹窗
    function closeModal() {
        modal.style.display = 'none';
        modalForm.reset();
    }


})()
