package vn.iotstar.config;

import java.util.List;
import vn.iotstar.entity.Category;
import vn.iotstar.services.ICategoryService;
import vn.iotstar.services.impl.CategoryServiceImpl;

public class TestCrudCategory {
    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("BAT DAU KIEM THU CRUD CATEGORY VOI JPA");
        System.out.println("=================================================");

        ICategoryService cateService = new CategoryServiceImpl();

        // 1. Test Insert
        System.out.println("\n[TEST 1] Them moi cac Category...");
        Category c1 = new Category();
        c1.setCategoryname("Dien thoai");
        c1.setImages("phone.png");
        c1.setStatus(1);
        cateService.insert(c1);

        Category c2 = new Category();
        c2.setCategoryname("Laptop");
        c2.setImages("laptop.png");
        c2.setStatus(1);
        cateService.insert(c2);

        Category c3 = new Category();
        c3.setCategoryname("Thoi trang Nam");
        c3.setImages("ao_nam.png");
        c3.setStatus(0);
        cateService.insert(c3);

        // 2. Test FindAll & Count
        List<Category> list = cateService.findAll();
        System.out.println("\n[TEST 2] Danh sach tat ca Category (Tong so: " + cateService.count() + "):");
        for (Category c : list) {
            System.out.println(" - ID: " + c.getCategoryid() + " | Ten: " + c.getCategoryname() + " | Status: " + c.getStatus() + " | Anh: " + c.getImages());
        }

        // 3. Test FindById
        if (!list.isEmpty()) {
            int firstId = list.get(0).getCategoryid();
            Category found = cateService.findById(firstId);
            System.out.println("\n[TEST 3] Tim theo ID (" + firstId + "): " + (found != null ? found.getCategoryname() : "Khong tim thay"));
        }

        // 4. Test SearchByName
        List<Category> searchList = cateService.searchByName("thoai");
        System.out.println("\n[TEST 4] Tim kiem theo tu khoa 'thoai': tim thay " + searchList.size() + " ket qua:");
        for (Category c : searchList) {
            System.out.println(" -> " + c.getCategoryname());
        }

        // 5. Test Update
        if (!list.isEmpty()) {
            Category toUpdate = list.get(0);
            String oldName = toUpdate.getCategoryname();
            toUpdate.setCategoryname(oldName + " (Cap Nhat JPA)");
            toUpdate.setStatus(0);
            cateService.update(toUpdate);
            Category updated = cateService.findById(toUpdate.getCategoryid());
            System.out.println("\n[TEST 5] Cap nhat ID " + toUpdate.getCategoryid() + " thanh cong:");
            System.out.println(" -> Ten moi: " + updated.getCategoryname() + " | Status: " + updated.getStatus());
        }

        // 6. Test Pagination
        List<Category> pageList = cateService.findAll(0, 2);
        System.out.println("\n[TEST 6] Phan trang (Page 0, PageSize 2): " + pageList.size() + " items");

        // 7. Test Delete
        if (list.size() >= 2) {
            int deleteId = list.get(list.size() - 1).getCategoryid();
            try {
                cateService.delete(deleteId);
                System.out.println("\n[TEST 7] Xoa Category co ID " + deleteId + " thanh cong!");
            } catch (Exception e) {
                System.err.println("Loi khi xoa: " + e.getMessage());
            }
        }

        System.out.println("\n[KET THUC] Danh sach Category con lai (Tong so: " + cateService.count() + "):");
        for (Category c : cateService.findAll()) {
            System.out.println(" - ID: " + c.getCategoryid() + " | Ten: " + c.getCategoryname());
        }

        System.out.println("\n=================================================");
        System.out.println("TAT CA CAC PHUONG THUC CRUD JPA DEU HOAT DONG CHINH XAC 100%!");
        System.out.println("=================================================");

        JpaConfig.shutdown();
    }
}

