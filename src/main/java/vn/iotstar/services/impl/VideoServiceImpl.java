package vn.iotstar.services.impl;

import java.util.List;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.dao.VideoDao;
import vn.iotstar.entity.Video;
import vn.iotstar.services.IVideoService;

public class VideoServiceImpl implements IVideoService {

    private final IVideoDao videoDao = new VideoDao();

    @Override
    public void insert(Video video) {
        videoDao.insert(video);
    }

    @Override
    public void update(Video video) {
        videoDao.update(video);
    }

    @Override
    public void delete(String videoId) throws Exception {
        videoDao.delete(videoId);
    }

    @Override
    public Video findById(String videoId) {
        return videoDao.findById(videoId);
    }

    @Override
    public List<Video> findAll() {
        return videoDao.findAll();
    }

    @Override
    public List<Video> findAll(int page, int pageSize) {
        return videoDao.findAll(page, pageSize);
    }

    @Override
    public List<Video> findTop10Latest() {
        return videoDao.findTop10Latest();
    }

    @Override
    public List<Video> findByUserId(int userId) {
        return videoDao.findByUserId(userId);
    }

    @Override
    public List<Video> findByUserIdWithPaging(int userId, int page, int pageSize) {
        return videoDao.findByUserIdWithPaging(userId, page, pageSize);
    }

    @Override
    public int countByUserId(int userId) {
        return videoDao.countByUserId(userId);
    }

    @Override
    public int count() {
        return videoDao.count();
    }

    @Override
    public List<Video> searchByTitle(String title) {
        return videoDao.searchByTitle(title);
    }

    @Override
    public void increaseViews(String videoId) {
        videoDao.increaseViews(videoId);
    }
}
