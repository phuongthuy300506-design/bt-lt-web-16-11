package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.HashMap;
import java.util.Map;

public class JpaConfig {
    private static EntityManagerFactory factory;

    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (factory == null || !factory.isOpen()) {
            try {
                // 1. Thử kết nối unit chính jpa-hibernate-mysql (SQL Server)
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
                EntityManager testEm = factory.createEntityManager();
                testEm.close();
            } catch (Exception e) {
                System.err.println("JpaConfig: Ket noi SQL Server [1234567@a$] chua san sang: " + e.getMessage());
                try {
                    // Thử mật khẩu 1234@a$
                    Map<String, Object> props = new HashMap<>();
                    props.put("jakarta.persistence.jdbc.password", "1234@a$");
                    factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql", props);
                    EntityManager testEm = factory.createEntityManager();
                    testEm.close();
                } catch (Exception e2) {
                    System.err.println("JpaConfig: Chuyen sang che do du phong (jpa-hibernate-h2) de chay on dinh...");
                    try {
                        factory = Persistence.createEntityManagerFactory("jpa-hibernate-h2");
                    } catch (Exception e3) {
                        System.err.println("JpaConfig: Loi khoi tao persistence-unit: " + e3.getMessage());
                    }
                }
            }
        }
        return factory;
    }

    public static EntityManager getEntityManager() {
        EntityManagerFactory emf = getEntityManagerFactory();
        if (emf != null && emf.isOpen()) {
            return emf.createEntityManager();
        }
        return null;
    }

    public static synchronized void shutdown() {
        if (factory != null && factory.isOpen()) {
            factory.close();
            factory = null;
        }
    }
}
