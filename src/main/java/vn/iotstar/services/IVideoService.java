package vn.iotstar.services;

import java.util.List;
import vn.iotstar.entity.Video;

public interface IVideoService {
    void insert(Video video);

    void update(Video video);

    void delete(String videoId) throws Exception;

    Video findById(String videoId);

    List<Video> findAll();

    List<Video> findAll(int page, int pageSize);

    List<Video> findTop10Latest();

    List<Video> findByUserId(int userId);

    List<Video> findByUserIdWithPaging(int userId, int page, int pageSize);

    int countByUserId(int userId);

    int count();

    List<Video> searchByTitle(String title);

    void increaseViews(String videoId);
}
