import com.nanhang.utils.MD5Util;
import com.nanhang.utils.UUIDUtil;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

public class test {


    @Test
    public  void  test(){

      String s=  MD5Util.getMD5("123");
        System.out.println(s);
        String S1=UUIDUtil.getUUID();

    }
}
