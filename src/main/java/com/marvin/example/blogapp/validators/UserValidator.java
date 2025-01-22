package com.marvin.example.blogapp.validators;

import com.marvin.example.blogapp.models.User;
import com.marvin.example.blogapp.repositories.UserRepository;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

@Component
public class UserValidator implements Validator {

    private final UserRepository userRepository;
    public UserValidator(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * An instance of a User can be validated with this validator
     * @param c the {@link Class} that this {@link Validator} is
     * being asked if it can {@link #validate(Object, Errors) validate}
     * @return
     */
    @Override
    public boolean supports(Class<?> c) {
        return User.class.equals(c);
    }

    /**
     * Implement validations here
     * @param object the object that is to be validated
     * @param errors contextual state about the validation process
     */
    @Override
    public void validate(Object object, Errors errors) {
        User user = (User) object;

        User existingUser = userRepository.findByEmail(user.getEmail()).orElse(null);

        if (user.getId() == null) {
            if(!user.getPasswordConfirmation().equals(user.getPassword())){
                errors.rejectValue("passwordConfirmation", "Match");
            }
        }

        if (existingUser != null) {
            // registration case, check if the user doesn't exist already
            if (user.getId() == null) {
                errors.rejectValue("email", "Exists");
            }
            //  update case, check if the email belongs to another user
            else if (!existingUser.getId().equals(user.getId())) {
                errors.rejectValue("email", "Exists");
            }
        }
    }
}
