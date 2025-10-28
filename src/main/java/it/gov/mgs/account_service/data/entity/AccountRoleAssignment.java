package it.gov.mgs.account_service.data.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * Assegnazione di un {@link Role} ad un {@link Account} opzionalmente limitata ad una
 * specifica {@link Organization} (tabella ACCOUNT_ROLE_ASSIGNMENT). Include stato attivo ed ultimo login.
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ACCOUNT_ROLE_ASSIGNMENT")
public class AccountRoleAssignment extends AuditedEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", nullable = false, columnDefinition = "uniqueidentifier")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organization_id")
    private Organization organization;

    @Column(name = "active", nullable = false)
    private Boolean active;

    @Column(name = "last_login")
    private OffsetDateTime lastLogin;

}
