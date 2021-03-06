package com.zzrenfeng.base.utils;

import java.util.Arrays;
import java.util.IntSummaryStatistics;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * topic 生成数据库主键的方法
 * author: zhoujincheng
 * create: 2016/4/21 8:22
 */
public class UUIDUtils {

	/**
     * 获得一个UUID
     * <p>
     * return String UUID
     */
    public static String getUUID() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
    
    /**
     * @功能描述：获取一串32位小写字母UUID
     * @创  建  者： zhoujincheng
     * @版        本：V1.0.0
     * @创建日期：2017年7月20日 下午3:25:29
     *
     * @修  改  人：
     * @修改日期：
     * @修改描述：
     * @return
     */
    public static String getLowerUUID() {
    	return getUUID().toLowerCase();
    }
    /**
     * @功能描述：获取一串32位大写字母UUID
     * @创  建  者： zhoujincheng
     * @版        本：V1.0.0
     * @创建日期：2017年7月20日 下午3:27:07
     *
     * @修  改  人：
     * @修改日期：
     * @修改描述：
     * @return
     */
    public static String getUpperUUID() {
    	return getUUID().toUpperCase();
    }

    //获得指定数量的UUID
    public static String[] getUUID(int number) {
        if (number < 1) {
            return null;
        }
        String[] ss = new String[number];
        for (int i = 0; i < number; i++) {
            ss[i] = getUUID();
        }
        return ss;
    }

    public static void main(String... args){
     /*   System.out.println(getUUID());
        System.out.println(getLowerUUID());
        System.out.println(getUpperUUID());
        System.out.println("=========================使用Java 8新特性Lambda表达式输出String字符串");
        // 使用Java 8新特性Lambda表达式输出String字符串
		Arrays.asList(getUUID(3)).forEach(uuid -> System.out.println(uuid));
		System.out.println("=========================使用Java 8的方法引用更方便，方法引用由::双冒号操作符标示");
		// 使用Java 8的方法引用更方便，方法引用由::双冒号操作符标示，看起来像C++的作用域解析运算符
		Arrays.asList(getUUID(3)).forEach(System.out::println);
		System.out.println("=========================使用流API的收集器类，获取以“a”开头的UUID，使用filter方法");
		// 使用流API的收集器类，获取以“a”开头的UUID，其中filter中的断言（Predicate）必须返回一个boolean类型
		Arrays.asList(getUUID(3)).stream().filter(uuid -> uuid.startsWith("a")).forEach(System.out::println);
		System.out.println("=========================使用流API的收集器类，将每个UUID的小写字母变为大写，使用 map()方法");
		// 使用流API的收集器类，将每个UUID的小写字母变为大写，将“uuid -> uuid.toUpperCase()”表达式传到map()方法，后者将其应用到流中的每一个元素。
		Arrays.asList(getUUID(3)).stream().map(uuid -> uuid.toUpperCase()).forEach(System.out::println);
		System.out.println("=========================使用流API的收集器类，将每个UUID的小写字母变为大写，再将所有字符串合并到一起以“，”分隔， 使用reduce()方法");
		// 使用流API的收集器类，将每个UUID的小写字母变为大写，再将所有字符串合并到一起以“，”分隔，使用reduce()方法合并
		System.out.println(
			Arrays.asList(getUUID(3)).stream().map(uuid -> uuid.toUpperCase())
				.reduce((sumStr, uuid) -> (sumStr + "," + uuid)).get()
		);
		System.out.println("=========================使用流API的收集器类，将每个UUID的小写字母变为大写，再将所有字符串合并到一起以“，”分隔， 使用collect()方法");
		// 使用流API的收集器类，将每个UUID的小写字母变为大写，再将所有字符串合并到一起以“，”分隔，使用map()方法对流中的每个元素运用函数操作，再用collect()方法将所有元素收集合并
		System.out.println(
			Arrays.asList(getUUID(3)).stream().map(uuid -> uuid.toUpperCase())
				.collect(Collectors.joining(","))
		);
		
		System.out.println("=========================使用Java 8新特性，获取数组列表的个数、最小值、最大值、总和以及平均值");
		//获取数组列表的个数、最小值、最大值、总和以及平均值
		List<Integer> primes = Arrays.asList(2, 3, 5, 7, 11, 13, 17, 19, 23, 29);
		IntSummaryStatistics stats = primes.stream().mapToInt((x) -> (int)x).summaryStatistics();
		System.out.println("Highest prime number in List : " + stats.getMax());
		System.out.println("Lowest prime number in List : " + stats.getMin());
		System.out.println("Sum of all prime numbers : " + stats.getSum());
		System.out.println("Average of all prime numbers : " + stats.getAverage());*/
    	
    	System.out.println(UUID.randomUUID().toString());
    	
    }

}
