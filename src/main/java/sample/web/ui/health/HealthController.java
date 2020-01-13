package sample.web.ui.health;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.health.Health;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import sample.web.ui.Message;
import sample.web.ui.MessageRepository;

/*
 * REST API 추가(health check 목적)
 * @author leehw
 * @date 2020. 01. 13
 */
@RestController
public class HealthController {

    @Autowired
    MessageRepository messageRepository;

    @GetMapping("/checkHealth")
    public Health health() throws Exception {
        boolean health = check();
        if (!health) {

            int errorCode = 404;
            return Health.down().withDetail("ErrorCode", errorCode).build();
        }
        return Health.up().build();
    }

    public boolean check() throws Exception {
        try {
            Iterable<Message> messages = this.messageRepository.findAll();
        } catch (Exception e) {
            throw new Exception();
        }
        return true;
    }
}
