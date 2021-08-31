<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<%--加入了bootstrap样式 时间日历插件--%>
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<%--bootstrap分页插件F--%>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

	<script type="text/javascript">

	window.onload = main;
	function main(){

		// 为创建按钮绑定事件,打开添加操作的模态窗口
		$("#addBtn").click(fun1);

		// 条件日历组件  引入日历组件使用的class类选择器在需要加日历的标签中 加入class time
		$(".time").datetimepicker({
			minView: "month",		// 设置只显示到月份
			language:  'zh-CN',
			format: 'yyyy-mm-dd', 	// 显示格式
			autoclose: true,		// 选中自动关闭
			todayBtn: true,			// 显示今日按钮
			pickerPosition: "bottom-left"
		});

		// 为保存按钮绑定事件,执行添加操作
		$("#saveBtn").click(fun2);

		// 页面加载完毕之后触发一个方法
		// 默认展开列表的第一页,每页展现两条记录
	     	pageList(1,2);
		// 为查询按钮绑定事件,触发pageList方法
		$("#searchBtn").click(function(){
			/**
			 * 点击查询按钮的时候,我们应该将搜索框中的信息保存起来,保存到隐藏域中
			 */
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startDate").val()))
			$("#hidden-endDate").val($.trim($("#search-endDate").val()))
			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
		});


	/*	//全选的复选框绑定事件点击时所有的复选框状态为选中状态
		为市场活动的复选框绑定单击事件
		全选框绑定事件
			$("#qx").click(function () {
          //当该复选框的状态为被选中时所有的其他复选框状态为选择状态
			//prop（"",某种状态）添加属性
			$(":checkbox[name='xz']").prop("checked",this.checked())
		})

		* 因为复选框为动态生成的元素不能像普通绑定事件的形式
		*   以on的形式绑定
		*  动态生成的元素,我们要以on方法的形式来触发事件
		 * 语法:
		 * 		$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		 * //checkbox[name='xz']动态的  外层是td 和tr也是动态的 再外层是tbody为有效的元素
		 *
		 * $("#activityBody").on("click",":checked[name='zx']",function(){
		 *
		 *     //如果被选中的复选框的长度与复选框的长度相同添加属性全选框的状态为选中
		 *    $("#qx").prop("checked",$(":checked[name='tx']").length==$(":checked[name='tx']:checked".length));
		 *   })
		* */



		$("#qx").click(function (){
			$(":checkbox[name='xz']").prop("checked",this.checked);
		});


		// 以下这种做法是不行的
		// 因为动态生成的元素,是不能够以普通绑定事件的形式来进行操作的
		/*$(":checkbox[name='xz']").click(function(){
			alert(123);
			if($(":checkbox[name='xz']:first").prop("checked") && $(":checkbox[name='xz']:eq(1)").prop("checked")){
			$("#qx").prop("checked",true);}
		})*/
		/**
		 * 动态生成的元素,我们要以on方法的形式来触发事件
		 * 语法:
		 * 		$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		 */
		$("#activityBody").on("click",$(":checkbox[name='xz']"),function(){
			/*if($(":checkbox[name='xz']:first").prop("checked") && $(":checkbox[name='xz']:eq(1)").prop("checked")){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}*/
			$("#qx").prop("checked",$(":checkbox[name='xz']").length == $(":checkbox[name='xz']:checked").length);
		});

		// 为删除按钮绑定事件,执行市场活动的删除操作
		$("#deleteBtn").click(fun3);

		// 为修改按钮绑定事件,打开修改的模态窗口
		$("#editBtn").click(fun4);

		// 为更新按钮绑定事件,执行市场活动的修改操作
		$("#updateBtn").click(fun5);
	}



	function fun1(){
		/**
		 * 操作模态窗口的方式
		 *		需要操作的模态窗口的jquery对象,调用modal方法,为该方法传递参数  show:打开模态窗口  hide:关闭模态窗口
		 */
		/*$.ajax({
			url:"workbench/activity/getUserList.do",
			type:"get",
			data:{},
			dataType:"json",
			success:function(data){
				//取得用户信息列表中的所有id和对应的name
				// each遍历的加到用户下拉框中每一个名字代表每一个选项
				var  html="<option></option>"
				$.each(data,function (i,n) {
                     //i代表下标 n代表该下标对应的对象
					//遍历把每个用户连起来
					html+="<option value='"+n.id+"'>"+n.name+"</option>"
				})

				$("#create-owner").html(html);
				//取得当前用户登入的id  登入的用户信息存放在session域中
				//取到的是id读取的id对应的文本值n.name
				var id=$(sessionStorage.user.id)
				$("#create-owner").val(id)
				//最后打开模态窗口
			}
		})*/


		// $("#createActivityModal").modal("show");

		// 走后台,目的是为了取得用户信息列表,为所有者下拉框取值
		$.ajax({
			url:"workbench/activity/getUserList.do",
			type:"get",
			data:{},
			dataType:"json",
			success:function(data){
				/**
				 * 	List<User> uList
				 * data
				 *  	[{"id":?,"name":?....},{2},{3}...]
				 */
				var html = "<option></option>"

				// 遍历出来的每一个n,就是每一个user对象
				$.each(data,function (i,n){

					html += "<option value='"+n.id+"'>"+n.name+"</option>";

				})

				$("#create-owner").html(html);

				// 将当前登录的用户,设置为下拉框默认的选项
				/**
				 * 	<select>
				 *  	<option value="40f6cdea0bd34aceb77492a1656d9fb3">张三</option>
				 *  	<option value="06f5fc056eac41558a964f96daa7f27c">李四</option>
				 *	</selecr>
				 */

				// 取得当前登录用户的id
				// 在js中使用el表达式,el表达式一定要套用在字符串中
				var id = "${sessionScope.user.id}";
				$("#create-owner").val(id);   // 默认select标签选中当前用户

				// 所有者下拉框处理完毕后,展现模态窗口
				$("#createActivityModal").modal("show");
			}
		})
	}

	function fun2(){

		/*
		*     $.ajax({
        url:"workbench/activity/save.do",
        data:{
        * 需要向后端传递的参数$.trim()去空格
        * "owner":$.trim($("#create-owner").val()),
		  "name":$.trim($("#create-name").val()),
		  "startDate":$.trim($("#create-startDate").val()),
		  "endDate":$.trim($("#create-endDate").val()),
		  "cost":$.trim($("#create-cost").val()),
		  "description":$.trim($("#create-description").val())
        *
        * },
        * 添加 修改 删除 对数据改动的操作使用post方式
        type:"post",
        dataType:"json",
        success:function(data){
        * 如果成功返回true
        * if(data.success){
        * 局部刷新添加的数据
        * 得到表单的dom对象然后每次点击创建按钮后执行表单重置
        * reset方法是js独有的所有把jQuery对象转为dom对象后调用
        * $("#activityAddForm")[0].reset();//表单重置
        * $("#createActivityModal").modal("hide");关闭模态窗口
        * }
        * 失败则弹框失败信息
        *
        * }
    })*/
		$.ajax({
			url:"workbench/activity/save.do",
			type:"post",
			data:{
				"owner":$.trim($("#create-owner").val()),
				"name":$.trim($("#create-name").val()),
				"startDate":$.trim($("#create-startDate").val()),
				"endDate":$.trim($("#create-endDate").val()),
				"cost":$.trim($("#create-cost").val()),
				"description":$.trim($("#create-description").val())
			},
			dataType:"json",
			success:function(data){
				if(data){
					// 添加成功后
					// 刷新市场活动信息列表(局部刷新)
					// pageList(1,2);
					/**
					 *	$("#activityPage").bs_pagination('getOption', 'currentPage')
					 *		操作后停留在当前页
					 *
					 *	$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
					 *		操作后维持已经设置好的每页展示的记录数
					 *
					 *	这两个参数不需要我们任何的修改操作
					 *	直接使用即可
					 * */

					// 做完添加操作后,应该回到第一页,维持每页展现的记录数
					pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

					// 清空添加操作模态窗口中的数据
					// 提交表单
					// $("#activityAddForm").submit();

					/**
					 * 注意:
					 * 		我们拿到了form表单的jquery对象,
					 * 		对于表单的jquery对象,提供了submit()方法让我们提交表单
					 * 		但是表单的jquery对象,没有为我们提供reset()方法让我们重置表单(坑: idea为我们提示了又reset()方法)
					 *
					 * 		虽然jquery对象没有为我们提供reset()方法,但是原生的js为我们提供了reset方法
					 *		我们要将jquery对象,转换为原生js对象
					 *
					 *		jquery对象转换为dom对象:
					 *			jquery对象[下标]
					 *
					 *		dom对象如何转换为jquery对象:
					 *			$(dom)
					 */
					//把jQuery对象转为dom对象调用dom对象的方法来重置表单
					//$("#activityAddForm")[0].reset();

					// 关闭添加操作的模态窗口
					$("#createActivityModal").modal("hide");

				}else{
					alert("添加市场活动失败");
				}
			}
		})
	}

	/**
	 * 对于所有的关系行数据库,做前端的分页相关操作的基础组件
	 * 就是pageNo和pageSize
	 * pageNo: 页码
	 * pageSize: 每页展现的记录数
	 *
	 * pageList方法: 就是发出ajax请求到后台,从后台取得最新的市场活动信息列表数据
	 * 				通过响应回来的数据,局部刷新市场活动信息列表
	 *
	 * 	我们都在哪些情况下,需要调用pageList方法(什么情况下需要刷新一下市场活动列表)
	 * 		1. 点击左侧菜单中"市场活动"超链接,需要刷新市场活动列表
	 * 		2. 添加,修改,删除后,需要刷新市场活动列表
	 * 		3. 点击查询按钮的时候,需要刷新市场活动列表
	 * 		4. 点击分页组件的时候
	 *
	 * 		以上为pageList方法制定了六个入口,也就是说,在以上6个操作执行完毕后,我们必须要调用pageList方法,刷新市场活动信息列表
	 */


	/*定义一个function方法pagelist专门用于分页操作
	* function pagelist(pageNo,pageSize)//pageNo 为显示第几页 pageSize为显示的条目数
	* {
	*     //发出Ajax请求让显示出相应页的信息
	*
            $.ajax({
            url:"workbench/activity/pagelist.do",
            data:{
            * //需要的参数我们需要显示第几页以及每一页显示多少条
            * //或者进行条件查询时也会显示相应的信息
            * "pageNo":pageNo
            * "pageList":pagelist
            * //下面的参数在不执行查询操作时都为空 所有需要使用动态SQL语句的条件约束
            * //并且每次取得参数前去掉空格去掉防止数据空值的情况
            * "name":$.trim($("search-name").val()),
            * "owner":$.trim($("#search-owner").val()),
			  "startDate":$.trim($("#search-startDate").val()),
			  "endDate":$.trim($("#search-endDate").val()),
            *
            * },
            type:"get",//只进行查询操作
            dataType:"json",
            success:function(data){
            *
            * //从后台需要得到的数据是每一个市场活动
            * [{市场活动1}，{。。。2}，。。。] List<Activity> dataLsit  是一个list集合被转为json数组
            * //总条数 {tatol:?}
            *改json数组为
            * {"tatol":?,"datalist":[{市场活动1},{市场活动2}]}
            *
            * 得到数据后再遍历的拼接到div中 显示
            * $.each(data.datalist,function(i,n){
            * 	html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value='+n.id+' /></td>';//每个多选框的值都使用该信息唯一的id标识
					* //\'workbench/activity/detail.do?id='+n.id+'\'最外层使用单引号里面的单引号需要使用\转义
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';
            * })
            * 得到该div的jQuery对象进行赋值拼接
            * $("#activityBody").html(html);
            *
            *
            * }
            })
	* }
	*
	* */
	function pageList(pageNo,pageSize){

		// 将全选的复选框的对勾干掉
		$("#qx").prop("checked",false);

		// 查询前,将隐藏域中保存的信息取出来,重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({
			url:"workbench/activity/pageList.do",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,

				// 这个trim()方法太重要了,直接防止数据库中数据出现空格的情况
				//当不点击查询条件是这四个参数为空需要在SQL语句中加入动态SQL
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val()),
			},
			dataType:"json",
			success:function(data){
				/**
				 * data
				 * 	我们需要的: 市场活动信息列表
				 * 	[{市场活动1},{2},{3}...] List<Activity> aList
				 * 	一会分页插件需要的: 查询出来的总记录数
				 *	{"total":?} int total
				 *
				 *	{"total":?,"dataList":[{市场活动1},{2},{3}...]}
				 */
				var html = "";

				// 每一个n就是每一个市场活动对象
				$.each(data.dataList,function(i,n){

					html += '<tr class="active">';
					/*每个市场活动的复选框 */
					html += '<td><input type="checkbox" name="xz" value='+n.id+' /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';

				})

				$("#activityBody").html(html);

				// 计算总页数
				//var totale1=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize)+1;

				// 数据处理完毕后,结合分页查询,对前端展现分页信息
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数
					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					// 该回调函数是在点击分页组件的时候触发的
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}

	function fun3(){

		// 找到复选框中所有选中的复选框的jquery对象
		var $xz = $(":checkbox[name='xz']:checked");
		if($xz.length == 0){
			alert("请选择需要删除的记录");
		}else{
			// 肯定选了,而且有可能是1条,有可能是多条

			if(confirm("确定删除所选中的记录吗?")){

				// url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx....

				// 拼接参数
				var param = "";
				// 将$xz中的每一个dom对象遍历出来,取其value值,就相当于取得了需要删除的记录的id
				for(var i=0;i<$xz.length;i++){
					param += "id="+$($xz[i]).val();

					// 如果不是最后一个元素,需要在后面追加一个&符
					if(i<$xz.length-1){
						param += "&";
					}
				}
				// alert(param);

				$.ajax({
					url:"workbench/activity/delete.do",
					type:"post",
					data:param,
					dataType:"json",
					success:function(data){
						/**
						 * data
						 * 	{"success":true/false}
						 *
						 */

						if(data){
							// 删除成功后
							// 回到第一页,维持每页展现的记录数
							// pageList(1,2);
							pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert("删除市场活动失败");
						}
					}
				})
			}
		}
	}

	// 为修改按钮绑定事件,打开修改操作的模态窗口
	function fun4(){
		var $xz = $(":checkbox[name='xz']:checked");
		if($xz.length == 0){
			alert("请选择要修改的记录");
		} else if($xz.length>1){
			alert("只能选择一条记录进行修改");
		} else if($xz.length == 1){
			var id = $xz.val();
			$.ajax({
				url:"workbench/activity/getUserListAndActivity.do",
				type:"get",
				data:{
					"id":id
				},
				dataType:"json",
				success:function(data){
					/**
					 * data
					 * 	用户列表
					 * 	市场活动对象
					 * 	{"uList":[{用户1},{2},{3}...],"a":{市场活动}}
					 */

					// 处理所有者下拉框
					var html = "<option></option>";

					$.each(data.uList,function(i,n){
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#edit-owner").html(html);

					// 处理单条activity
					$("#edit-id").val(data.a.id);
					$("#edit-name").val(data.a.name);
					$("#edit-owner").val(data.a.owner);
					$("#edit-endDate").val(data.a.endDate);
					$("#edit-cost").val(data.a.cost);
					$("#edit-startDate").val(data.a.startDate);
					$("#edit-description").val(data.a.description);

					// 所有的值都填写好之后,打开修改操作的模态窗口
					$("#editActivityModal").modal("show");
				}
			})
		}
	}

	function fun5() {
		/**
		 * 在实际项目开发中,一定是按照先做添加,再做修改的这种顺序
		 * 所以,为了节省开发时间,修改操作一般都是copy添加这种操作
		 */

		$.ajax({
			url:"workbench/activity/update.do",
			type:"post",
			data:{
				"id":$.trim($("#edit-id").val()),
				"owner":$.trim($("#edit-owner").val()),
				"name":$.trim($("#edit-name").val()),
				"startDate":$.trim($("#edit-startDate").val()),
				"endDate":$.trim($("#edit-endDate").val()),
				"cost":$.trim($("#edit-cost").val()),
				"description":$.trim($("#edit-description").val())
			},
			dataType:"json",
			success:function(data){
				/**
				 * data
				 * 		{"success":true/false}
				 */
				if(data){

					// 修改成功后
					// 刷新市场活动信息列表(局部刷新)
					// pageList(1,2);

					/**
					 * 修改操作之后,应该维持在当前页,维持每页展现的记录数
					 */
					pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
							,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

					// 关闭修改操作的模态窗口
					$("#editActivityModal").modal("hide");

				}else{
					alert("修改市场活动失败");
				}
			}
		})
	}


</script>
</head>
<body>
<%--<input type="hidden"自定义隐藏域用于分页操作时对条件查询的输入结果进行保存--%>
	<input type="hidden" id="hidden-name" />
	<input type="hidden" id="hidden-owner" />
	<input type="hidden" id="hidden-startDate" />
	<input type="hidden" id="hidden-endDate" />

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<%--引用了时间组件  readonly只读的状态--%>
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<!--
						data-dismiss="modal"
							表示关闭模态窗口
					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id" />

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" />
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" />
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" />
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--
									关于文本域textarea:
										1. 一定是要以标签对的形式来呈现,正常状态下标签对要紧紧的挨着
										2. textarea虽然是以标签对的形式来呈现的,但是它也是属于表单元素input范畴
											我们所有的对于textarea的取值和赋值操作,应该统一使用val()方法 (而不是html()方法)
								-->
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name" />
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner" />
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--
						点击创建按钮,观察两个属性和属性值

						data-toggle="modal":
							表示触发该按钮,将要打开一个模态窗口

						data-target="#createActivityModal":
							表示要打开哪个模态窗口,通过#id的形式找到该窗口

						现在我们是以属性和属性值的方式写在了button元素中,用来打开模态窗口,
						但是这样做是有问题的:
							问题在于没有办法对按钮的功能进行扩充

						所以我们未来的实际项目开发,对于触发模态窗口的操作,一定不要写死在元素当中,
						应该由我们自己写js代码来操作
					-->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<%--全选框的按钮--%>
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
                   <%--分页执行后的页面在这里插入--%>
				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>