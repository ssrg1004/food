package web.miniProject.dto;

public class ReviewerImageDTO {

    private int image_id;
    private int post_id;

    private String file_name;

    private String is_thumbnail;

    private int image_order;

    public ReviewerImageDTO() {}

    public int getImage_id() {
        return image_id;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }

    public int getPost_id() {
        return post_id;
    }

    public void setPost_id(int post_id) {
        this.post_id = post_id;
    }

    public String getFile_name() {
        return file_name;
    }

    public void setFile_name(String file_name) {
        this.file_name = file_name;
    }

    public String getIs_thumbnail() {
        return is_thumbnail;
    }

    public void setIs_thumbnail(String is_thumbnail) {
        this.is_thumbnail = is_thumbnail;
    }

    public int getImage_order() {
        return image_order;
    }

    public void setImage_order(int image_order) {
        this.image_order = image_order;
    }
}