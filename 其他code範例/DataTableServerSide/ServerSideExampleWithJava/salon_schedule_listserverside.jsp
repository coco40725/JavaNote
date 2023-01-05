<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>IPET 寵物 | 美容專區 | 班表管理</title>
  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

  <!-- MultiDatePicker  -->
  <link rel="stylesheet" href="/static/backstage/plugins/jquery-ui/jquery-ui.min.css">
  <link rel="stylesheet" href="/static/backstage/plugins/jquery-ui-multidatepicker/css/jquery-ui.multidatespicker.css">
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="/static/backstage/plugins/fontawesome-free/css/all.css">
  <!-- DataTables -->
  <link rel="stylesheet" href="/static/backstage/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
  <link rel="stylesheet" href="/static/backstage/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
  <link rel="stylesheet" href="/static/backstage/plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
  <link rel="stylesheet" href="/static/backstage/plugins/datatables-select/css/select.bootstrap4.css">
  <!-- iCheck for checkboxes and radio inputs -->
  <link rel="stylesheet" href="/static/backstage/plugins/icheck-bootstrap/icheck-bootstrap.min.css">

  <!-- TODO: 目前先使用 完整css-->
  <!-- Theme style -->
  <link rel="stylesheet" href="/static/backstage/css/adminlte.css">



</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  <!--  Navbar -->
  <%@ include file="/templates/backstage/common/navbar.jsp" %>
  <!-- /.navbar -->

  <!-- 左邊選單區 Main Sidebar Container -->
  <%@ include file="/templates/backstage/common/sidebar.jsp" %>
  <!-- /.aside -->


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="/home">Home</a></li>
              <li class="breadcrumb-item">班表管理</li>
              <li class="breadcrumb-item active"><a href="salon_reserve_all.jsp">班表列表</a></li>
            </ol>
          </div>
        </div>
      </div><!-- /.container-fluid -->
    </section>

    <!-- Main content -->
    <section class="content">
      <div class="container-fluid">
        <div class="row">
          <div class="col-12">
            <div class="card">
              <div class="card-header">
                <h3 class="card-title"></h3>
              </div>
              <!-- /.card-header -->
              <div class="card-body">
                <div>
                  <button type="submit" data-toggle="modal" data-target="#AddModal" class="btn btn-outline-secondary row-add"><i class="fas fa-solid fa-plus"></i> 新增 </button>
                   <p></p>
                </div>
                <table id="scheduleTable" class="table table-bordered table-striped  display">
                  <thead>
                  <tr>
                    <th>班表編號</th>
                    <th>美容師姓名</th>
                    <th>助理1姓名</th>
                    <th>助理2姓名</th>
                    <th>班表日期</th>
                    <th>班表時段</th>
                    <th>預約單編號</th>
                    <th>員工備註</th>
                    <th></th>
                    <th></th>
                  </tr>
                  </thead>

                </table>
              </div>
              <!-- /.card-body -->
            </div>
            <!-- /.card -->
          </div>
          <!-- /.col -->
        </div>
        <!-- /.row -->
      </div>
      <!-- /.container-fluid -->
    </section>
    <!-- /.content -->

    <!-- Remove Modal content   -->
    <div class="modal fade" id="RemoveModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">資料刪除</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            確認要刪除此筆資料?
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
            <button type="submit" class="btn btn-danger btn-remove-confirm">確認</button>
          </div>
        </div>
      </div>
    </div>
    <!-- /.Remove Modal content   -->

    <!-- Edit Modal content   -->
    <div class="modal fade" id="EditModal" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">資料編輯</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form>
              <%-- 美容師 --%>
              <div class="form-group">
                <label for="GROOMER_name-modal-edit" class="col-form-label">美容師姓名</label>
                <select id="GROOMER_name-modal-edit" class="form-control">
                  <option value="1">xxx</option>
                  <option value="2">阿扁</option>
                  <option value="3">死亡之握</option>
                  <option value="4">席包子</option>
                </select>
              </div>
              <%-- 助理1 --%>
              <div class="form-group">
                <label for="ASST_name_1-modal-edit" class="col-form-label">助理1姓名</label>
                <select id="ASST_name_1-modal-edit" class="form-control">
                  <option value="1">xxx</option>
                  <option value="2">阿扁</option>
                  <option value="3">死亡之握</option>
                  <option value="4">席包子</option>
                </select>
              </div>
              <%-- 助理2 --%>
              <div class="form-group">
                <label for="ASST_name_2-modal-edit" class="col-form-label">助理2姓名</label>
                <select id="ASST_name_2-modal-edit" class="form-control">
                  <option value="1">xxx</option>
                  <option value="2">阿扁</option>
                  <option value="3">死亡之握</option>
                  <option value="4">席包子</option>
                </select>
              </div>
              <%-- 日期 --%>
              <div class="form-group">
                <label for="schDate-modal-edit" class="col-form-label">班表日期</label>
                <input id="schDate-modal-edit" type="date" class="form-control">
              </div>
              <%-- 時段 --%>
              <div>
                <label for="schPeriod-modal-edit" class="col-form-label">班表時段</label>
                <select id="schPeriod-modal-edit" class="form-control">
                  <option value="1">上午</option>
                  <option value="2">下午</option>
                  <option value="3">晚上</option>
                </select>
              </div>
              <%-- 備註 --%>
              <div>
                <label for="schNote-edit-modal" class="col-form-label">員工備註</label>
                <textarea id="schNote-edit-modal" class="form-control"></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
            <button type="submit" class="btn btn-primary btn-edit-confirm">確認修改</button>
          </div>
        </div>
      </div>
    </div>
    <!-- /. Edit Modal content   -->

    <!--  Add Modal content  -->
    <div class="modal fade" id="AddModal" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">資料新增</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form>
              <%-- 美容師 --%>
              <div class="form-group">
                <label for="GROOMER_name-modal-add" class="col-form-label">美容師姓名</label>
                <select id="GROOMER_name-modal-add" class="form-control">
                  <option value="1">xxx</option>
                  <option value="2">阿扁</option>
                  <option value="3">死亡之握</option>
                  <option value="4">席包子</option>
                </select>
              </div>
              <%-- 助理1 --%>
              <div class="form-group">
                <label for="ASST_name_1-modal-add" class="col-form-label">助理1姓名</label>
                <select id="ASST_name_1-modal-add" class="form-control">
                  <option value="1">xxx</option>
                  <option value="2">阿扁</option>
                  <option value="3">死亡之握</option>
                  <option value="4">席包子</option>
                </select>
              </div>
              <%-- 助理2 --%>
              <div class="form-group">
                <label for="ASST_name_2-modal-add" class="col-form-label">助理2姓名</label>
                <select id="ASST_name_2-modal-add" class="form-control">
                  <option value="1">xxx</option>
                  <option value="2">阿扁</option>
                  <option value="3">死亡之握</option>
                  <option value="4">席包子</option>
                </select>
              </div>
              <%-- 日期 --%>
              <div class="form-group">
                <label for="schDate-modal-add" class="col-form-label">班表日期</label>
                <input type="text" class="form-control" id="schDate-modal-add">
              </div>
              <%-- 時段 --%>
              <div class="form-group">
                <label class="col-form-label">班表時段</label>
                <p></p>
                <div class="icheck-primary d-inline jobPeriod-add">
                  <input type="checkbox" value="1" id="jobPeriod-add1" class="jobPeriod-add">
                  <label for="jobPeriod-add1">上午</label>
                </div>
                <div class="icheck-primary d-inline">
                  <input type="checkbox" value="2" id="jobPeriod-add2" class="jobPeriod-add">
                  <label for="jobPeriod-add2">下午</label>
                </div>
                <div class="icheck-primary d-inline jobPeriod-add">
                  <input type="checkbox" value="3" id="jobPeriod-add3" class="jobPeriod-add">
                  <label for="jobPeriod-add3">晚上</label>
                </div>
              </div>
              <%-- 備註 --%>
              <div>
                <label for="schNote-add-modal" class="col-form-label">員工備註</label>
                <textarea id="schNote-add-modal" class="form-control"></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
            <button type="submit" class="btn btn-primary btn-add-confirm">確認新增</button>
          </div>
        </div>
      </div>
    </div>
    <!-- /. Add Modal content   -->
  </div>
  <!-- /.content-wrapper -->

  <!-- Main Footer -->
  <%@ include file="/templates/backstage/common/footer.jsp" %>

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-dark">
    <!-- Control sidebar content goes here -->
  </aside>
  <!-- /.control-sidebar -->
</div>
<!-- ./wrapper -->

<!-- jQuery -->
<script src="/static/backstage/plugins/jquery/jquery.min.js"></script>
<script src="/static/backstage/plugins/jquery-ui/jquery-ui.min.js"></script>
<!-- Bootstrap 4 -->
<script src="/static/backstage/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE -->
<script src="/static/backstage/js/adminlte.js"></script>

<!-- DataTables  & Plugins -->
<script src="/static/backstage/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/static/backstage/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
<script src="/static/backstage/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
<script src="/static/backstage/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
<script src="/static/backstage/plugins/datatables-buttons/js/dataTables.buttons.min.js"></script>
<script src="/static/backstage/plugins/datatables-buttons/js/buttons.bootstrap4.min.js"></script>
<script src="/static/backstage/plugins/jszip/jszip.min.js"></script>
<script src="/static/backstage/plugins/pdfmake/pdfmake.min.js"></script>
<script src="/static/backstage/plugins/pdfmake/vfs_fonts.js"></script>
<script src="/static/backstage/plugins/datatables-buttons/js/buttons.html5.min.js"></script>
<script src="/static/backstage/plugins/datatables-buttons/js/buttons.print.min.js"></script>
<script src="/static/backstage/plugins/datatables-buttons/js/buttons.colVis.min.js"></script>
<script src="/static/backstage/plugins/datatables-select/js/dataTables.select.js" ></script>

<!-- MultiDatePicker -->
<script src="/static/backstage/plugins/jquery-ui-multidatepicker/js/jquery-ui.multidatespicker.js"></script>


<!-- sidebar menu Class -->
<script>
  $("p:contains(班表管理)").closest("li").addClass("menu-open");
  $("p:contains(班表列表)").closest("a").addClass("active");
</script>

<!-- DataTable show -->
<script>
  $(document).ready(function() {
    $('#schDate-modal-add').multiDatesPicker({
      dateFormat: 'yy-mm-dd'
    });

    // https://github.com/dubrox/Multiple-Dates-Picker-for-jQuery-UI/issues/67
    <!-- 解決 MultiDatePicker 閃爍問題並處理需點兩次才可關閉的問題 -->
    $.datepicker._selectDateOverload = $.datepicker._selectDate;
    $.datepicker._selectDate = function(id, dateStr) {
      var target = $(id);
      var inst = this._getInst(target[0]);
      inst.inline = true;
      $.datepicker._selectDateOverload(id, dateStr);
      inst.inline = false;
      target[0].multiDatesPicker.changed = false;
      this._updateDatepicker(inst);
    };
    <!-- /.解決 MultiDatePicker 閃爍問題並處理需點兩次才可關閉的問題 -->

    let table = $('#scheduleTable').DataTable({
      autoWidth: false,
      responsive: true,
      lengthChange: true,
      info: true,
      altEditor: false,     // Enable altEditor,
      pagingType: "full_numbers",
      processing: true,
      serverSide: true,
      // displayStart: 0,
      // pageLength:10,
      ajax: {
        url: "/job_data",
        type: "POST"
      },
      //  填寫直接顯示的欄位，需要與thead tfoot 對應
      "columns": [
        { data: "schID",  responsivePriority: 1, className: "SCH_ID"},
        { data: "groomerName",  responsivePriority: 2, className: "GROOMER_name"},
        { data: "asstID1Name",  responsivePriority: 3, className: "ASST_name_1"},
        { data: "asstID2Name",  responsivePriority: 4, className: "ASST_name_2"},
        { data: "schDate",  responsivePriority: 5, className: "SCH_DATE"},
        { data: "schPeriod", className: "SCH_PERIOD"},
        { data: "ampId", className: "APM_ID"},
        { data: "employeeNote", className: "EMPLOYEE_NOTE"},
        {
          data: null,
          defaultContent:
                  '<button type="submit" class="btn btn-light" data-toggle="modal" data-target="#EditModal" data-whatever="@mdo">' +
                  '<i class="fas fa-solid fa-pen"></i>' +
                  '</button>',
          className: 'row-edit dt-center',
          orderable: false,
          responsivePriority: 6
        },
        {
          data: null,
          defaultContent:
                  '<button type="submit" class="btn btn-danger" data-toggle="modal" data-target="#RemoveModal">\n' +
                  ' <i class="fas fa-solid fa-trash"></i>' +
                  '</button>',
          className: 'row-remove dt-center',
          orderable: false,
          responsivePriority: 7
        }

      ],
      select: {
        style: 'single',
        toggleable: false
      },
      order: [[1, 'asc']]
    });


    // TODO: (需要重寫) Delete data from modal
    $('#scheduleTable tbody').on('click', 'td.row-remove', function (){
      // TODO: 從資料庫移除資料
      let targetData = $(event.target).closest("tr");
      $('.modal-footer').on('click', '.btn-remove-confirm', function (){
        targetData.remove();
        // table.ajax().reload();
        $('#RemoveModal').modal('hide');
      })
    });

    // TODO: (需要重寫)  Edit data from modal
    $('#scheduleTable tbody').on('click', 'td.row-edit', function (){
      // TODO: 將資料庫的資料顯示在 Modal 上
      let targetData = $(event.target).closest("tr")[0]; // get tr data
      if (targetData.querySelector("td.APM_ID").innerText.trim() !== ""){
        $('#schPeriod-modal').closest('div').html(
                `<label for="jobId-modal" class="col-form-label">班表編號</label>
                 <input type="text" readonly class="form-control" value="123">
                `
        )
        $('#schDate-modal').attr("readonly",true);
      }

      //  1. edit the GROOMER_name, ASST_name_1, ASST_name_2
      $('#GROOMER_name-modal').val(1);
      $('#ASST_name_1-modal').val(2);
      $('#ASST_name_2-modal').val(3);

      // 2. edit the schDate
      console.log(targetData.querySelector("td.schDate").innerText);
      $('#schDate-modal').val(targetData.querySelector("td.schDate").innerText);


      //  3. edit the schPeriod
      $('#schPeriod-modal').val(1);


      // TODO: 從資料庫修改資料，並重新顯現在 table 上 (以下方法由於目前是使用靜態資料，故是失效的)
      $('.modal-footer').on('click', '.btn-edit-confirm', function (){

        //  1. edit the GROOMER_name, ASST_name_1, ASST_name_2

        // 2. edit the schDate
        targetData.querySelector("td.schDate").innerText = $('#schDate-modal').val();

        // 3. update the schPeriod
        targetData.querySelector("td.schPeriod").innerText = $('#schPeriod-modal').val();

        $("#EditModal").modal("hide");
      })
    })

    // TODO: (需要重寫) Add data from modal
    $('.row-add').on('click', function (){
      // clean the previous data
      $('#GROOMER_name-modal-add').val("");
      $('#ASST_name_1-modal-add').val("");
      $('#ASST_name_2-modal-add').val("");
      $('#schDate-modal-add').val("");
      $('input.jobPeriod-add').prop("checked", false);

      $('.modal-footer').on('click', '.btn-add-confirm', function (){
        console.log($('#GROOMER_name-modal-add').val());
        console.log($('#ASST_name_1-modal-add').val());
        console.log($('#ASST_name_2-modal-add').val());
        console.log($('#schDate-modal-add').val());
        let period = [];
        for (let p of $('input.jobPeriod-add:checked')){
          period.push(p.value);
        }
        console.log(period);

        $('#AddModal').modal('hide');
      })
    })


  });
</script>
</body>
</html>
